package openapi

import (
	"fmt"
	"github.com/cloudquery/cq-gen/naming"
	"github.com/getkin/kin-openapi/openapi3"
	"github.com/iancoleman/strcase"
	"strings"
)

type DescriptionSource struct {
	doc *openapi3.T
}

func NewDescriptionSource(path string) (*DescriptionSource, error) {
	doc, err := openapi3.NewLoader().LoadFromFile(path)
	if err != nil {
		return nil, err
	}
	return &DescriptionSource{doc: doc}, nil
}

func (d DescriptionSource) FindDescription(paths ...string) (string, error) {
	if len(paths) < 1 {
		return "", nil
	}
	schemaRef, ok := d.doc.Components.Schemas[strcase.ToSnake(paths[0])]
	if !ok {
		return "", fmt.Errorf("resource not found %s", paths)
	}
	if len(paths) == 1 {
		return schemaRef.Value.Description, nil
	}
	return d.FindColumnDescription(schemaRef, paths[1:])
}

func (d DescriptionSource) FindColumnDescription(schemaRef *openapi3.SchemaRef, parts []string) (string, error) {
	c := naming.CamelToSnake(parts[0])
	var childRef *openapi3.SchemaRef
	for k, p := range getSchemaProperties(schemaRef) {
		if k == c {
			childRef = p
			break
		}
		if naming.CamelToSnake(k) == c {
			childRef = p
			break
		}
		if strings.ToLower(strcase.ToCamel(k)) == strings.ToLower(parts[0]) {
			childRef = p
			break
		}
		if strings.HasPrefix(k, strings.ToLower(c)) {
			childRef = p
			break
		}
	}
	if childRef == nil {
		return "", nil
	}
	if len(parts) == 1 {
		return childRef.Value.Description, nil
	}
	return d.FindColumnDescription(childRef, parts[1:])
}

func getSchemaProperties(schemaRef *openapi3.SchemaRef) openapi3.Schemas {
	if schemaRef.Value.Type == "array" {
		return schemaRef.Value.Items.Value.Properties
	}
	var props = make(openapi3.Schemas)
	if schemaRef.Value.Properties == nil {
		for _, s := range schemaRef.Value.AllOf {
			for k, v := range s.Value.Properties {
				props[k] = v
			}
		}
		return props
	}
	return schemaRef.Value.Properties
}
