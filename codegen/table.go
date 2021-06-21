package codegen

import (
	"fmt"
	"github.com/cloudquery/cq-gen/code"
	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-gen/naming"
	"github.com/cloudquery/cq-gen/rewrite"
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
	"github.com/iancoleman/strcase"
	"github.com/jinzhu/inflection"
	"go/ast"
	"go/types"
	"path"
	"strings"
)

const defaultImplementation = `panic("not implemented")`
const sdkPath = "github.com/cloudquery/cq-provider-sdk"

func (b builder) buildTable(parentTable *TableDefinition, resource config.ResourceConfig) (*TableDefinition, error) {
	ro, err := b.finder.FindTypeFromName(resource.Path)
	if err != nil {
		return nil, err
	}

	fullName := inflection.Plural(resource.Name)
	if parentTable != nil && !strings.HasPrefix(strings.ToLower(resource.Name), strings.ToLower(inflection.Singular(parentTable.Name))) {
		fullName = fmt.Sprintf("%s%s", inflection.Singular(parentTable.Name), strings.Title(inflection.Plural(resource.Name)))
	}

	table := &TableDefinition{
		Name:        fullName,
		DomainName:  resource.Domain + strcase.ToCamel(resource.Name),
		TableName:   strings.ToLower(fmt.Sprintf("%s_%s_%s", resource.Service, resource.Domain, naming.CamelToSnake(fullName))),
		parentTable: parentTable,
	}

	if resource.Description != "" {
		table.Description = resource.Description
	}

	// will only mark table function as copied
	b.rewriter.GetFunctionBody(ToGo(table.DomainName), "")

	b.logger.Debug("Building table", "table", table.TableName)
	if err := b.buildTableFunctions(table, resource); err != nil {
		return nil, err
	}

	if err := b.addUserDefinedColumns(table, resource); err != nil {
		return nil, err
	}

	named := ro.(*types.Named)
	if err := b.buildColumns(table, named, resource, "", ""); err != nil {
		return nil, err
	}

	if err := b.buildTableRelations(table, resource); err != nil {
		return nil, err
	}

	return table, nil
}

func (b builder) buildTableFunctions(table *TableDefinition, resource config.ResourceConfig) error {

	var err error
	table.Resolver, err = b.buildFunctionDefinition(table, &config.FunctionConfig{
		Name: strcase.ToLowerCamel(fmt.Sprintf("fetch%s%s", strings.Title(resource.Domain), strings.Title(table.Name))),
		Body: defaultImplementation,
		Path: path.Join(sdkPath, "provider/schema.TableResolver"),
	})

	if resource.IgnoreError != nil {
		table.IgnoreErrorFunc, err = b.buildFunctionDefinition(table, resource.IgnoreError)
		if err != nil {
			return err
		}
	}
	if resource.Multiplex != nil {
		table.MultiplexFunc, err = b.buildFunctionDefinition(table, resource.Multiplex)
		if err != nil {
			return err
		}
	}

	if resource.DeleteFilter != nil {
		table.DeleteFilterFunc, err = b.buildFunctionDefinition(table, resource.DeleteFilter)
		if err != nil {
			return err
		}
	}
	if resource.PostResourceResolver != nil {
		table.PostResourceResolver, err = b.buildFunctionDefinition(table, resource.PostResourceResolver)
		if err != nil {
			return err
		}
	}

	return nil
}

func (b builder) buildFunctionDefinition(table *TableDefinition, cfg *config.FunctionConfig) (*FunctionDefinition, error) {
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

	body := defaultImplementation
	if cfg.Body != "" {
		body = cfg.Body
	}

	funcBody := b.rewriter.GetFunctionBody(cfg.Name, body)
	if funcBody == defaultImplementation {
		b.logger.Debug("Using default implementation for function", "function", cfg.Name)
	}
	def := &FunctionDefinition{
		Name:      cfg.Name,
		Body:      funcBody,
		Type:      ro,
		Arguments: getFunctionParams(signature),
	}
	if cfg.Generate {
		// Set signature of function as the generated resolver name
		def.Signature = cfg.Name
		table.Functions = append(table.Functions, def)
	}
	return def, nil
}

func (b builder) buildTableRelations(table *TableDefinition, cfg config.ResourceConfig) error {

	for _, relCfg := range cfg.Relations {
		// if relation already exists i.e was built from one of the columns we skip it
		if table.RelationExists(relCfg.Name) {
			continue
		}
		relTable, err := b.buildTableRelation(table, relCfg)
		if err != nil {
			return err
		}
		if relTable == nil {
			continue
		}
		table.Relations = append(table.Relations, relTable)
	}
	return nil
}

func (b builder) buildTableRelation(parentTable *TableDefinition, cfg config.ResourceConfig) (*TableDefinition, error) {
	if cfg.LimitDepth != 0 && b.depth >= cfg.LimitDepth {
		b.logger.Warn("depth level exceeded", "parent_table", parentTable.TableName, "table", cfg.Name)
		return nil, nil
	}
	b.logger.Debug("building column relation", "parent_table", parentTable.TableName, "table", cfg.Name)
	if cfg.EmbedRelation {
		ro, err := b.finder.FindTypeFromName(cfg.Path)
		if err != nil {
			return nil, err
		}
		columnName := cfg.Name
		if cfg.EmbedSkipPrefix {
			columnName = ""
		}
		if err := b.buildColumns(parentTable, ro.(*types.Named), cfg, "", columnName); err != nil {
			return nil, err
		}
		return nil, nil
	}

	innerB := builder{
		finder:   b.finder,
		rewriter: b.rewriter,
		logger:   b.logger,
		depth:    b.depth + 1,
	}
	rel, err := innerB.buildTable(parentTable, cfg)
	if err != nil {
		return nil, err
	}
	rel.Columns = append([]ColumnDefinition{{
		Name:        strings.ToLower(fmt.Sprintf("%s_id", naming.CamelToSnake(inflection.Singular(parentTable.Name)))),
		Type:        schema.TypeUUID,
		Description: fmt.Sprintf("Unique ID of %s table (FK)", parentTable.TableName),
		Resolver:    &FunctionDefinition{Signature: "schema.ParentIdResolver"}},
	}, rel.Columns...)

	return rel, nil
}

func (b builder) addUserDefinedColumns(table *TableDefinition, resource config.ResourceConfig) error {
	for _, uc := range resource.UserDefinedColumn {
		b.logger.Debug("adding user defined column", "table", table.TableName, "column", uc.Name)
		colDef := ColumnDefinition{
			Name:        uc.Name,
			Description: uc.Description,
			Type:        schema.ValueTypeFromString(uc.Type),
		}
		if uc.GenerateResolver {
			if uc.Resolver != nil {
				b.logger.Warn("overriding already defined column resolver", "column", uc.Name, "resolver", uc.Resolver.Name)
			}
			columnResolver, err := b.buildFunctionDefinition(table, &config.FunctionConfig{
				Name:     ToGoPrivate(fmt.Sprintf("resolve%s%s%s", strings.Title(resource.Domain), strings.Title(inflection.Singular(table.Name)), strings.Title(uc.Name))),
				Body:     defaultImplementation,
				Path:     path.Join(sdkPath, "provider/schema.ColumnResolver"),
				Generate: true,
			})
			if err != nil {
				return err
			}
			colDef.Resolver = columnResolver
		} else if uc.Resolver != nil {
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

func (b builder) buildColumns(table *TableDefinition, named *types.Named, resource config.ResourceConfig, fieldPath string, columnPath string) error {

	st := named.Underlying().(*types.Struct)
	pkg, _ := code.PkgAndType(resource.Path)
	rw, _ := rewrite.NewFromImportPath(pkg)
	docs := rw.GetStructDocs(named.Obj().Name())
	if docs != nil && table.Description == "" {
		table.Description = strings.ReplaceAll(strings.SplitN(docs.Text(), ". ", 2)[0], "\n", " ")
	}
	spec := rw.GetStructSpec(named.Obj().Name())
	for i := 0; i < st.NumFields(); i++ {
		field, tag := st.Field(i), st.Tag(i)
		// Skip unexported, if the original field has a "-" tag or the field was requested to be skipped via config.
		if !field.Exported() || strings.Contains(tag, "-") {
			b.logger.Debug("skipping column", "table", table.TableName, "column", field.Name())
			continue
		}

		b.logger.Debug("building column", "table", table.TableName, "column", field.Name())
		if err := b.buildTableColumn(table, fieldPath, columnPath, field, resource, spec); err != nil {
			return fmt.Errorf("table %s build column %s failed. %w", table.DomainName, field.Name(), err)
		}
	}
	return nil
}

func (b builder) buildTableColumn(table *TableDefinition, fieldPath, columnPath string, field *types.Var, resource config.ResourceConfig, spec *ast.TypeSpec) error {
	fieldName := field.Name()
	colDef := ColumnDefinition{
		Name:     b.getColumnName(fieldName, columnPath),
		Type:     0,
		Resolver: nil,
	}

	cfg := resource.GetColumnConfig(colDef.Name)
	if cfg.Skip {
		return nil
	}

	if cfg.Rename != "" {
		colDef.Name = cfg.Rename
		colDef = b.addPathResolver(fieldName, fieldPath, colDef)
	}

	if cfg.Description != "" {
		colDef.Description = cfg.Description
	} else if spec != nil && !resource.DisableReadDescriptions {
		desc := getSpecColumnDescription(spec, field.Name())
		if desc != "" {
			colDef.Description = desc
		}
	}

	if cfg.GenerateResolver {
		if colDef.Resolver != nil {
			b.logger.Warn("overriding already defined column resolver", "column", fieldName, "resolver", colDef.Resolver.Name)
		}
		columnResolver, err := b.buildFunctionDefinition(table, &config.FunctionConfig{
			Name:     ToGoPrivate(fmt.Sprintf("resolve%s%s%s", strings.Title(resource.Domain), strings.Title(inflection.Singular(table.Name)), strings.Title(colDef.Name))),
			Body:     defaultImplementation,
			Path:     path.Join(sdkPath, "provider/schema.ColumnResolver"),
			Generate: true,
		})
		if err != nil {
			return err
		}
		colDef.Resolver = columnResolver
		// Set signature of function as the generated resolver name
		colDef.Resolver.Signature = colDef.Resolver.Name
	}

	var valueType schema.ValueType
	if schema.ValueTypeFromString(cfg.Type) != schema.TypeInvalid {
		valueType = TypeUserDefined
	} else {
		valueType = getValueType(field.Type())
		if valueType == schema.TypeInvalid {
			return fmt.Errorf("unsupported type %T for %s", field.Type(), b.getColumnName(field.Name(), columnPath))
		}
	}

	switch valueType {
	case TypeRelation:
		obj := getNamedType(field.Type()).Obj()
		b.logger.Debug("building column relation", "table", table.TableName, "column", field.Name(), "object", obj.Name())
		relationCfg := resource.GetRelationConfig(obj.Name())
		if relationCfg == nil {
			relationCfg = &config.ResourceConfig{
				Service: resource.Service,
				Domain:  resource.Domain,
				Name:    colDef.Name,
				Path:    fmt.Sprintf("%s.%s", obj.Pkg().Path(), obj.Name()),
			}
		}
		relationCfg.Path = fmt.Sprintf("%s.%s", obj.Pkg().Path(), obj.Name())
		rel, err := b.buildTableRelation(table, *relationCfg)
		if err != nil {
			return err
		}
		if rel != nil {
			table.Relations = append(table.Relations, rel)
		}
	case TypeEmbedded:
		b.logger.Debug("Building embedded column", "table", table.TableName, "column", field.Name())
		if err := b.buildColumns(table, getNamedType(field.Type()), resource, getParentPath(fieldPath, field.Name(), false), getParentPath(columnPath, field.Name(), cfg.SkipPrefix)); err != nil {
			return err
		}

	case TypeUserDefined:
		b.logger.Info("Changing column to user defined", "table", table.TableName, "column", field.Name(), "valueType", valueType, "userDefinedType", cfg.Type)
		colDef.Type = schema.ValueTypeFromString(cfg.Type)
		table.Columns = append(table.Columns, colDef)
	default:
		colDef.Type = valueType
		table.Columns = append(table.Columns, b.addPathResolver(fieldName, fieldPath, colDef))
	}
	return nil
}

func (b builder) addPathResolver(fieldName, fieldPath string, definition ColumnDefinition) ColumnDefinition {
	if definition.Resolver != nil {
		return definition
	}
	if fieldPath != "" {
		b.logger.Debug("Adding embedded resolver path", "column", strcase.ToCamel(definition.Name), "field", fieldName)
		definition.Resolver = &FunctionDefinition{
			Signature: fmt.Sprintf("schema.PathResolver(\"%s.%s\")", fieldPath, fieldName),
		}
		return definition
	}
	// use strcase here since sdk uses it
	if strcase.ToCamel(definition.Name) == fieldName {
		return definition
	}
	b.logger.Debug("Adding path resolver column name. camelCase is not same as original field name", "column", strcase.ToCamel(definition.Name), "field", fieldName)
	definition.Resolver = &FunctionDefinition{
		Signature: fmt.Sprintf("schema.PathResolver(\"%s\")", fieldName),
	}
	return definition
}

func (b builder) getColumnName(fieldName string, parentFieldPath string) string {
	if parentFieldPath == "" {
		return naming.CamelToSnake(fieldName)
	}
	parentNameParts := strings.Replace(parentFieldPath, ".", "", -1)
	if strings.HasSuffix(parentNameParts, fieldName) {
		b.logger.Debug("removing redundant suffix from column name", "parentName", parentNameParts, "column", fieldName)
		return naming.CamelToSnake(parentNameParts)
	}
	if strings.HasPrefix(fieldName, parentNameParts) {
		b.logger.Debug("removing redundant prefix from column name", "parentName", parentNameParts, "column", fieldName)
		return naming.CamelToSnake(fieldName)
	}
	return strings.ToLower(fmt.Sprintf("%s_%s", naming.CamelToSnake(parentNameParts), naming.CamelToSnake(fieldName)))
}

func getParentPath(fieldPath, field string, skipPrefix bool) string {
	if skipPrefix {
		return fieldPath
	}
	if fieldPath == "" {
		return field
	}
	return fmt.Sprintf("%s.%s", fieldPath, field)
}

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

func getSpecColumnDescription(spec *ast.TypeSpec, columnName string) string {
	s := spec.Type.(*ast.StructType)
	for _, f := range s.Fields.List {
		if f.Names[0].Name != columnName {
			continue
		}
		if f.Comment != nil {
			return f.Comment.Text()
		}
		if f.Doc != nil {
			data := strings.SplitN(f.Doc.Text(), ". ", 2)[0]
			return strings.TrimSpace(strings.ReplaceAll(data, "\n", " "))
		}
	}
	return ""
}
