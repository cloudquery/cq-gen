package codegen

import (
	"fmt"
	"github.com/cloudquery/cq-gen/code"
	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-gen/codegen/source"
	"github.com/cloudquery/cq-gen/naming"
	"github.com/cloudquery/cq-gen/rewrite"
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
	"github.com/hashicorp/go-hclog"
	"github.com/iancoleman/strcase"
	"github.com/jinzhu/inflection"
	"go/types"
	"os"
	"path"
	"strings"
)

// BuildMeta is information passed when the TableBuilder is traversing over a source.Object to build it's table
type BuildMeta struct {
	// Depth represents the logical depth traversal in the build, the depth is used to avoid infinite recursion
	Depth int
	// ColumnPath is the logical traversal on the column, the path extends if it hits embedded objects.
	ColumnPath string
	// FieldPath is the dot notated path of the resource this expected, this is used for PathResolvers
	FieldPath string
}

type TableBuilder struct {
	finder   code.Finder
	source   source.DataSource
	rewriter *rewrite.Rewriter
	log      hclog.Logger
}

func NewTableBuilder(source source.DataSource) TableBuilder {
	return TableBuilder{
		source:   source,
		rewriter: nil,
		log: hclog.New(&hclog.LoggerOptions{
			Level:  hclog.Debug,
			Output: os.Stdout,
		}),
	}
}

func (tb TableBuilder) BuildTable(parentTable *TableDefinition, resourceCfg config.ResourceConfig) (*TableDefinition, error) {

	fullName := GetResourceName(parentTable, resourceCfg)
	table := &TableDefinition{
		Name:        fullName,
		DomainName:  GetFileName(resourceCfg),
		TableName:   GetTableName(resourceCfg.Service, resourceCfg.Domain, fullName),
		parentTable: parentTable,
		Options:     resourceCfg.TableOptions,
		Description: resourceCfg.Description,
	}
	// will only mark table function as copied
	// TODO: rename domain name since its confusing to resource name
	//tb.rewriter.GetFunctionBody(template.ToGo(table.DomainName), "")
	tb.log.Debug("Building table", "table", table.TableName)

	if resourceCfg.Path == "" {
		return table, nil
	}
	obj, err := tb.source.Find(resourceCfg.Path)
	if err != nil {
		return nil, err
	}
	if err := tb.buildColumns(table, obj, resourceCfg, BuildMeta{}); err != nil {
		return nil, err
	}

	return table, nil
}

func (tb TableBuilder) buildColumns(table *TableDefinition, object source.Object, resourceCfg config.ResourceConfig, meta BuildMeta) error {
	for _, f := range object.Fields() {
		tb.log.Debug("building column", "field", f.Name(), "object", object.Name(), "table", table.Name)
		if err := tb.buildColumn(table, f, resourceCfg, meta); err != nil {
			return err
		}
	}
	return nil
}

func (tb TableBuilder) buildColumn(table *TableDefinition, field source.Object, resourceCfg config.ResourceConfig, meta BuildMeta) error {

	// Build initial column definition
	fieldName := field.Name()
	colDef := ColumnDefinition{
		Name:     GetColumnName(fieldName, meta),
		Type:     0,
		Resolver: nil,
	}
	// check if configuration wants column to be skipped
	cfg := resourceCfg.GetColumnConfig(colDef.Name)
	if cfg.Skip {
		return nil
	}
	// Set column description, usually source.Object contains a description, but it can also be overridden by the column
	// configuration.
	colDef.Description = GetColumnDescription(field, cfg, meta)

	// Set Resolver
	// TODO: set resolver

	valueType := field.Type()
	if schema.ValueTypeFromString(cfg.Type) != schema.TypeInvalid {
		valueType = source.TypeUserDefined
	}
	if valueType == schema.TypeInvalid {
		return fmt.Errorf("unsupported type %T for %s", field.Type(), GetColumnName(field.Name(), meta))
	}
	switch valueType {
	case source.TypeRelation:
		// TODO: support relations
	case source.TypeEmbedded:
		tb.log.Debug("Building embedded column", "table", table.TableName, "column", field.Name())
		if err := tb.buildColumns(table, field, resourceCfg, BuildColumnMeta(field, meta, cfg)); err != nil {
			return err
		}
	case source.TypeUserDefined:
		tb.log.Debug("Changing column to user defined", "table", table.TableName, "column", field.Name(), "valueType", valueType, "userDefinedType", cfg.Type)
		colDef.Type = schema.ValueTypeFromString(cfg.Type)
		table.Columns = append(table.Columns, colDef)
	default:
		colDef.Type = valueType
		// TODO: add path resolver
		table.Columns = append(table.Columns, colDef)
	}
	return nil
}

func (tb TableBuilder) addUserDefinedColumns(table *TableDefinition, resource config.ResourceConfig) error {
	for _, uc := range resource.UserDefinedColumn {
		tb.log.Debug("adding user defined column", "table", table.TableName, "column", uc.Name)
		colDef := ColumnDefinition{
			Name:        uc.Name,
			Description: uc.Description,
			Type:        schema.ValueTypeFromString(uc.Type),
		}
		if uc.GenerateResolver {
			if uc.Resolver != nil {
				tb.log.Warn("overriding already defined column resolver", "column", uc.Name, "resolver", uc.Resolver.Name)
			}
			columnResolver, err := tb.buildFunctionDefinition(table, &config.FunctionConfig{
				Name:     fmt.Sprintf("resolve%s%s%s", strings.Title(resource.Domain), strings.Title(inflection.Singular(table.Name)), strings.Title(uc.Name)),
				Body:     defaultImplementation,
				Path:     path.Join(sdkPath, "provider/schema.ColumnResolver"),
				Generate: true,
			})
			if err != nil {
				return err
			}
			colDef.Resolver = columnResolver
		} else if uc.Resolver != nil {
			ro, err := tb.finder.FindObjectFromName(uc.Resolver.Path)
			if err != nil {
				return fmt.Errorf("user defined column %s requires resolver definition %w", uc.Name, err)
			}
			colDef.Resolver = &FunctionDefinition{Type: ro}
		}
		table.Columns = append(table.Columns, colDef)
	}
	return nil
}


func (tb TableBuilder) buildFunctionDefinition(table *TableDefinition, cfg *config.FunctionConfig) (*FunctionDefinition, error) {
	ro, err := tb.finder.FindObjectFromName(cfg.Path)
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

	funcBody := tb.rewriter.GetFunctionBody(cfg.Name, body)
	if funcBody == defaultImplementation {
		tb.log.Debug("Using default implementation for function", "function", cfg.Name)
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


func BuildColumnMeta(field source.Object, parentMeta BuildMeta, cfg config.ColumnConfig) BuildMeta {
	meta := BuildMeta{
		Depth:      0,
		ColumnPath: field.Name(),
		FieldPath:  field.Name(),
	}
	if !cfg.SkipPrefix {
		meta.ColumnPath = fmt.Sprintf("%s_%s", parentMeta.ColumnPath, meta.ColumnPath)
	}
	if meta.FieldPath != "" {
		meta.FieldPath = fmt.Sprintf("%s.%s", parentMeta.FieldPath, field)
	}
	return meta
}

func GetColumnDescription(obj source.Object, cfg config.ColumnConfig, _ BuildMeta) string {
	if cfg.Description != "" {
		return cfg.Description
	}
	return obj.Description()
}

func GetColumnName(fieldName string, meta BuildMeta) string {
	if meta.ColumnPath == "" {
		return naming.CamelToSnake(fieldName)
	}
	parentNameParts := strings.Replace(meta.ColumnPath, "_", "", -1)
	if strings.HasSuffix(parentNameParts, fieldName) {
		return naming.CamelToSnake(parentNameParts)
	}
	if strings.HasPrefix(fieldName, parentNameParts) {
		return naming.CamelToSnake(fieldName)
	}
	return strings.ToLower(fmt.Sprintf("%s_%s", naming.CamelToSnake(parentNameParts), naming.CamelToSnake(fieldName)))
}

func GetResourceName(parentTable *TableDefinition, resourceCfg config.ResourceConfig) string {
	resourceName := inflection.Plural(resourceCfg.Name)
	if resourceCfg.NoPluralize {
		resourceName = resourceCfg.Name
	}
	fullName := resourceName
	if parentTable != nil && !strings.HasPrefix(strings.ToLower(resourceCfg.Name), strings.ToLower(inflection.Singular(parentTable.Name))) {
		return fmt.Sprintf("%s%s", inflection.Singular(parentTable.Name), strings.Title(resourceName))
	}
	return fullName
}

// GetFileName returns the fully qualified file name {domain}_{resource_name}.go or {resource_name}.go
func GetFileName(resourceCfg config.ResourceConfig) string {
	if resourceCfg.Domain == "" {
		return strcase.ToCamel(resourceCfg.Name)
	}
	return resourceCfg.Domain + strcase.ToCamel(resourceCfg.Name)
}

func GetTableName(service, domain, resource string) string {
	if domain == "" {
		return strings.ToLower(strings.Join([]string{service, naming.CamelToSnake(resource)}, "_"))
	}
	return strings.ToLower(strings.Join([]string{service, domain, naming.CamelToSnake(resource)}, "_"))
}
