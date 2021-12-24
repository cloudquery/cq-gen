package codegen

import (
	"fmt"
	"strings"

	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-gen/naming"
	"github.com/jinzhu/inflection"
)

func GetColumnName(fieldName string, meta BuildMeta) string {
	if meta.ColumnPath == "" {
		return naming.CamelToSnake(fieldName)
	}
	if strings.HasSuffix(meta.ColumnPath, fieldName) {
		return naming.CamelToSnake(meta.ColumnPath)
	}
	if strings.HasPrefix(fieldName, meta.ColumnPath) {
		return naming.CamelToSnake(fieldName)
	}
	return strings.ToLower(fmt.Sprintf("%s_%s", naming.CamelToSnake(meta.ColumnPath), naming.CamelToSnake(fieldName)))
}

func GetResourceName(parentTable *TableDefinition, resourceCfg *config.ResourceConfig) string {
	resourceName := inflection.Plural(resourceCfg.Name)
	if resourceCfg.NoPluralize {
		resourceName = resourceCfg.Name
	}
	fullName := resourceName
	if parentTable != nil && !strings.HasPrefix(strings.ToLower(resourceCfg.Name), strings.ToLower(inflection.Singular(parentTable.Name))) {
		return fmt.Sprintf("%s_%s", inflection.Singular(parentTable.Name), resourceName)
	}
	return fullName
}

// GetFileName returns the fully qualified file name {domain}_{resource_name}.go or {resource_name}.go
func GetFileName(resourceCfg *config.ResourceConfig) string {
	if resourceCfg.Domain != "" {
		return fmt.Sprintf("%s_%s.go", resourceCfg.Domain, resourceCfg.Name)
	}
	return fmt.Sprintf("%s.go", resourceCfg.Name)
}

func GetTableName(parentTable *TableDefinition, service, domain, resource string) string {
	if parentTable != nil && !strings.HasPrefix(strings.ToLower(resource), strings.ToLower(inflection.Singular(parentTable.Name))) {
		return fmt.Sprintf("%s_%s", inflection.Singular(parentTable.TableName), strings.ToLower(resource))
	}
	if domain == "" {
		return strings.ToLower(strings.Join([]string{service, naming.CamelToSnake(resource)}, "_"))
	}
	return strings.ToLower(strings.Join([]string{service, domain, naming.CamelToSnake(resource)}, "_"))
}
