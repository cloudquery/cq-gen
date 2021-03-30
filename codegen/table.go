package codegen

import (
	"fmt"
	"github.com/cloudquery/cloudquery-plugin-sdk/plugin/schema"
	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-gen/codegen/templates"
	"github.com/iancoleman/strcase"
	"github.com/jinzhu/inflection"
	"go/types"
	"path"
	"strings"
)

const defaultImplementation = `panic("not implemented")`
const sdkPath = "github.com/cloudquery/cloudquery-plugin-sdk"

func (b builder) buildTable(resource config.ResourceConfig) (*TableDefinition, error) {
	ro, err := b.finder.FindTypeFromName(resource.Path)
	if err != nil {
		return nil, err
	}

	named := ro.(*types.Named)
	typeName := inflection.Plural(named.Obj().Name())

	table := &TableDefinition{
		OriginalName: named.Obj().Name(),
		TypeName:     resource.Domain + strcase.ToCamel(typeName),
		Name:         strings.ToLower(fmt.Sprintf("%s_%s_%s", resource.Service, resource.Domain, strcase.ToSnake(typeName))),
	}

	b.logger.Debug("Building table", "table", table.Name)
	if err := b.buildTableFunctions(table, typeName, resource); err != nil {
		return nil, err
	}

	if err := b.addUserDefinedColumns(table, resource); err != nil {
		return nil, err
	}

	if err := b.buildColumns(table, named, resource); err != nil {
		return nil, err
	}

	if err := b.buildTableRelations(table, named.Obj().Name(), resource); err != nil {
		return nil, err
	}

	return table, nil
}

func (b builder) buildTableFunctions(table *TableDefinition, typeName string, resource config.ResourceConfig) error {

	var err error
	table.Resolver, err = b.buildFunctionDefinition(&config.FunctionConfig{
		Name: templates.ToGoPrivate(fmt.Sprintf("fetch%s%s", strings.Title(resource.Domain), strings.Title(typeName))),
		Body: defaultImplementation,
		Path: path.Join(sdkPath, "plugin/schema.TableResolver"),
	})

	if resource.IgnoreError != nil {
		table.IgnoreErrorFunc, err = b.buildFunctionDefinition(resource.IgnoreError)
		if err != nil {
			return err
		}
	}
	if resource.Multiplex != nil {
		table.MultiplexFunc, err = b.buildFunctionDefinition(resource.Multiplex)
		if err != nil {
			return err
		}
	}

	if resource.DeleteFilter != nil {
		table.DeleteFilterFunc, err = b.buildFunctionDefinition(resource.DeleteFilter)
		if err != nil {
			return err
		}
	}
	return nil
}

func (b builder) buildFunctionDefinition(cfg *config.FunctionConfig) (*FunctionDefinition, error) {
	ro, err := b.finder.FindObjectFromName(cfg.Path)
	if err != nil {
		return nil, err
	}

	var signature *types.Signature
	switch t := ro.Type().(type) {
	case *types.Signature:
		signature = t
	case *types.Named:
		if _, ok := t.Underlying().(*types.Signature); !ok {
			return nil, fmt.Errorf("%s not a function", cfg.Path)
		}
		signature = t.Underlying().(*types.Signature)
	default:
		return nil, fmt.Errorf("%s not a function", cfg.Path)
	}

	return &FunctionDefinition{
		Name:      cfg.Name,
		Body:      b.rewriter.GetFunctionBody(cfg.Name, cfg.Body),
		Type:      ro,
		Arguments: getFunctionParams(signature),
	}, nil

}

func (b builder) buildTableRelations(table *TableDefinition, parent string, cfg config.ResourceConfig) error {

	for _, rel := range cfg.Relations {
		// if relation already exists i.e was built from one of the columns we skip it
		if table.RelationExists(rel.Name) {
			continue
		}
		relTable, err := b.buildTableRelation(parent, rel)
		if err != nil {
			return err
		}
		table.Relations = append(table.Relations, relTable)
	}
	return nil
}

func (b builder) buildTableRelation(parent string, cfg config.ResourceConfig) (*TableDefinition, error) {

	b.logger.Debug("building column relation", "parent_table", parent, "table", cfg.Name)
	rel, err := b.buildTable(cfg)
	if err != nil {
		return nil, err
	}
	rel.Columns = append(rel.Columns, ColumnDefinition{
		Name:     strings.ToLower(fmt.Sprintf("%s_id", parent)),
		Type:     schema.TypeUUID,
		Resolver: &FunctionDefinition{Signature: "schema.ParentIdResolver"},
	})

	return rel, nil
}

func (b builder) addUserDefinedColumns(table *TableDefinition, resource config.ResourceConfig) error {
	for _, uc := range resource.UserDefinedColumn {
		colDef := ColumnDefinition{
			Name:     uc.Name,
			Type:     uc.Type,
		}
		if uc.GenerateResolver {
			if uc.Resolver != nil {
				b.logger.Warn("overriding already defined column resolver", "column", uc.Name, "resolver", uc.Resolver.Name)
			}
			columnResolver, err := b.buildFunctionDefinition(&config.FunctionConfig{
				Name: templates.ToGoPrivate(fmt.Sprintf("resolve%s%s", strings.Title(resource.Domain), strings.Title(uc.Name))),
				Body: defaultImplementation,
				Path: path.Join(sdkPath, "plugin/schema.ColumnResolver"),
			})
			if err != nil {
				return err
			}
			colDef.Resolver = columnResolver
			// Set signature of function as the generated resolver name
			colDef.Resolver.Signature = colDef.Resolver.Name
			table.Functions = append(table.Functions, columnResolver)
		} else {
			ro, err := b.finder.FindObjectFromName(uc.Resolver.Path)
			if err != nil {
				return fmt.Errorf("user defined column %s requires resolver definition %w", uc.Name, err)
			}
			colDef.Resolver = &FunctionDefinition{Type: ro}
		}
		table.Columns = append(table.Columns, colDef)

	}
	return nil
}

func (b builder) buildColumns(table *TableDefinition, named *types.Named, resource config.ResourceConfig) error {
	st := named.Underlying().(*types.Struct)
	for i := 0; i < st.NumFields(); i++ {
		field, tag := st.Field(i), st.Tag(i)
		// Skip unexported, if the original field has a "-" tag or the field was requested to be skipped via config.
		if !field.Exported() || strings.Contains(tag, "-") {
			continue
		}
		valueType := getValueType(field.Type())
		if valueType == schema.TypeInvalid {
			return fmt.Errorf("unsupported type %T", field.Type())
		}
		b.logger.Debug("building column", "table", table.Name, "column", field.Name())
		if err := b.buildTableColumn(table, named.Obj().Name(), field, valueType, resource); err != nil {
			return fmt.Errorf("table %s build column %s failed. %w", table.TypeName, field.Name(), err)
		}
	}
	return nil
}

func (b builder) buildTableColumn(table *TableDefinition, parent string, field *types.Var, valueType schema.ValueType, resource config.ResourceConfig) error {

	fieldName := field.Name()
	colDef := ColumnDefinition{
		Name:     templates.ToSnake(fieldName),
		Type:     0,
		Resolver: nil,
	}

	columnName := strings.ToLower(strcase.ToSnake(field.Name()))
	cfg := resource.GetColumnConfig(columnName)
	if cfg.Skip {
		return nil
	}

	if cfg.Rename != "" {
		colDef.Name = cfg.Rename
		colDef.Resolver = &FunctionDefinition{
			Name:      "schema.PathResolver",
			Signature: fmt.Sprintf("schema.PathResolver(\"%s\")", fieldName),
		}
	}

	if cfg.GenerateResolver {
		if colDef.Resolver != nil {
			b.logger.Warn("overriding already defined column resolver", "column", fieldName, "resolver", colDef.Resolver.Name)
		}
		columnResolver, err := b.buildFunctionDefinition(&config.FunctionConfig{
			Name: templates.ToGoPrivate(fmt.Sprintf("resolve%s%s", strings.Title(resource.Domain), strings.Title(fieldName))),
			Body: defaultImplementation,
			Path: path.Join(sdkPath, "plugin/schema.TableResolver"),
		})
		if err != nil {
			return err
		}
		colDef.Resolver = columnResolver
		// Set signature of function as the generated resolver name
		colDef.Resolver.Signature = colDef.Resolver.Name
		table.Functions = append(table.Functions, columnResolver)
	}
	if cfg.Type != schema.TypeInvalid {
		valueType = TypeUserDefined
	}
	switch valueType {
	case TypeRelation:
		obj := getNamedType(field.Type()).Obj()
		b.logger.Debug("building column relation", "table", table.Name, "column", field.Name(), "object", obj.Name())
		relationCfg := resource.GetRelationConfig(obj.Name())
		if relationCfg == nil {
			relationCfg = &config.ResourceConfig{
				Service: resource.Service,
				Domain:  resource.Domain,
				Name:    strcase.ToSnake(obj.Name()), // Add prefix?
				Path:    fmt.Sprintf("%s.%s", obj.Pkg().Path(), obj.Name()),
			}
		}
		relationCfg.Path = fmt.Sprintf("%s.%s", obj.Pkg().Path(), obj.Name())
		rel, err := b.buildTableRelation(parent, *relationCfg)
		if err != nil {
			return err
		}
		table.Relations = append(table.Relations, rel)
	case TypeEmbedded:
		b.logger.Debug("Building embedded column", "table", table.Name, "column", field.Name())
		if err := b.buildEmbeddedColumns(table, parent, field.Name(), getNamedType(field.Type()), cfg, resource); err != nil {
			return err
		}

	case TypeUserDefined:
		b.logger.Info("Changing column to user defined", "table", table.Name, "column", field.Name(), "valueType", valueType, "userDefinedType", cfg.Type)
		colDef.Type = cfg.Type
		table.Columns = append(table.Columns, colDef)
	default:
		colDef.Type = valueType
		table.Columns = append(table.Columns, colDef)
	}
	return nil
}

func (b builder) buildEmbeddedColumns(table *TableDefinition, parentTable string, parentColumnName string, named *types.Named, cfg config.ColumnConfig, resource config.ResourceConfig) error {
	columns := make([]ColumnDefinition, 0)

	st := named.Underlying().(*types.Struct)
	for i := 0; i < st.NumFields(); i++ {
		field, tag := st.Field(i), st.Tag(i)
		columnCfg := cfg.GetColumnConfig(field.Name())
		// Skip unexported, if the original field has a "-" tag or the field was requested to be skipped via config.
		if !field.Exported() || strings.Contains(tag, "-") || columnCfg.Skip {
			continue
		}
		valueType := getValueType(field.Type())
		if valueType == schema.TypeInvalid {
			return fmt.Errorf("unsupported type %T", field.Type())
		}

		switch valueType {
		case TypeRelation:
			obj := getNamedType(field.Type()).Obj()
			b.logger.Debug("building column relation", "table", table.Name, "column", field.Name(), "object", obj.Name())
			relationCfg := resource.GetRelationConfig(obj.Name())
			if relationCfg == nil {
				relationCfg = &config.ResourceConfig{
					Service: resource.Service,
					Domain:  resource.Domain,
					Name:    strcase.ToSnake(obj.Name()), // Add prefix?
					Path:    fmt.Sprintf("%s.%s", obj.Pkg().Path(), obj.Name()),
				}
			}
			relationCfg.Path = fmt.Sprintf("%s.%s", obj.Pkg().Path(), obj.Name())
			rel, err := b.buildTableRelation(parentTable, *relationCfg)
			if err != nil {
				return err
			}
			table.Relations = append(table.Relations, rel)
		case TypeEmbedded:
			if err := b.buildEmbeddedColumns(table, parentTable, fmt.Sprintf("%s.field.Name()", parentColumnName), getNamedType(field.Type()), columnCfg, resource); err != nil {
				return err
			}
		default:
			parentNameParts := strings.Join(strings.Split(parentColumnName, "."), "_")
			columnName := strings.ToLower(fmt.Sprintf("%s_%s", strcase.ToSnake(parentNameParts), strcase.ToSnake(field.Name())))
			if cfg.SkipPrefix {
				columnName = strings.ToLower(strcase.ToSnake(field.Name()))
			}
			columns = append(columns, ColumnDefinition{
				Name:     columnName,
				Type:     valueType,
				Resolver: &FunctionDefinition{Signature: fmt.Sprintf("schema.PathResolver(\"%s\")", fmt.Sprintf("%s.%s", parentColumnName, field.Name()))},
			})
		}
	}
	return nil
}

// TODO: consider moving this as part of template so types will be added to imports if they don't exist
func getFunctionParams(sig *types.Signature) string {

	params := make([]string, sig.Params().Len())
	for i := 0; i < sig.Params().Len(); i++ {
		v := sig.Params().At(i)
		params[i] = fmt.Sprintf("%s %s", v.Name(), typeIdentifier(v.Type()))
	}
	if sig.Results().Len() == 0 {
		return fmt.Sprintf("(%s)", strings.Join(params, ","))
	}
	results := make([]string, sig.Results().Len())
	for i := 0; i < sig.Results().Len(); i++ {
		v := sig.Results().At(i)
		results[i] = fmt.Sprintf("%s", typeIdentifier(v.Type()))
	}
	if len(results) == 1 {
		return fmt.Sprintf("(%s) %s", strings.Join(params, ","), results[0])
	}
	return fmt.Sprintf("(%s) (%s)", strings.Join(params, ","), strings.Join(results, ","))
}
