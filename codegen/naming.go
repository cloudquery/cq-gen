package codegen

import (
	"fmt"
	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-gen/naming"
	"github.com/jinzhu/inflection"
	"strings"
)

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

func GetResourceName(parentTable *TableDefinition, resourceCfg *config.ResourceConfig) string {
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
func GetFileName(resourceCfg *config.ResourceConfig) string {
	if resourceCfg.Domain != "" {
		return fmt.Sprintf("%s_%s.go", resourceCfg.Domain, resourceCfg.Name)
	}
	return fmt.Sprintf("%s.go", resourceCfg.Name)
}

func GetTableName(service, domain, resource string) string {
	if domain == "" {
		return strings.ToLower(strings.Join([]string{service, naming.CamelToSnake(resource)}, "_"))
	}
	return strings.ToLower(strings.Join([]string{service, domain, naming.CamelToSnake(resource)}, "_"))
}

