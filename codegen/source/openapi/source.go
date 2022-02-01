package openapi

import (
	"fmt"

	"github.com/cloudquery/cq-gen/codegen/source"
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
	"github.com/getkin/kin-openapi/openapi3"
)

// DataSource of openapi reads objects from openapi spec
type DataSource struct {
	doc *openapi3.T
}

func NewOpenAPIDataSource(path string) (*DataSource, error) {
	doc, err := openapi3.NewLoader().LoadFromFile(path)
	if err != nil {
		return nil, err
	}
	return &DataSource{doc: doc}, nil
}

func (d DataSource) Find(path string) (source.Object, error) {
	schemaRef, ok := d.doc.Components.Schemas[path]
	if !ok {
		return nil, fmt.Errorf("resource not found %s", path)
	}
	return &Object{name: path, schema: schemaRef.Value}, nil
}

type Object struct {
	name   string
	schema *openapi3.Schema
	parent *Object
}

func (o Object) Name() string {
	return o.name
}

func (o Object) Fields() []source.Object {
	fields := make([]source.Object, 0)
	for name, s := range o.schema.Properties {
		fields = append(fields, &Object{name, s.Value, &o})
	}
	return fields
}

func (o Object) Description() string {
	return o.schema.Description
}

func (o Object) Type() schema.ValueType {
	return getValueType(o.schema)
}

func (o Object) Parent() source.Object {
	return o.parent
}

func (o Object) Exported() bool {
	return true
}

func (o Object) Path() string {
	return o.name
}

func getValueType(s *openapi3.Schema) schema.ValueType {
	switch s.Type {
	case "":
		if s.Items == nil {
			return schema.TypeInvalid
		}
		switch getValueType(s.Items.Value) {
		case schema.TypeBigInt:
			return schema.TypeIntArray
		case schema.TypeString:
			return schema.TypeStringArray
		case schema.TypeInet:
			return schema.TypeInetArray
		case source.TypeEmbedded:
			return source.TypeRelation
		}
	case "object":
		return source.TypeEmbedded
	case "string":
		switch s.Format {
		case "byte", "binary":
			return schema.TypeByteArray
		default:
			return schema.TypeString
		}
	case "boolean":
		return schema.TypeBool
	case "integer":
		return schema.TypeBigInt
	case "number":
		return schema.TypeFloat
	case "array":
		switch getValueType(s.Items.Value) {
		case schema.TypeBigInt:
			return schema.TypeIntArray
		case schema.TypeString:
			return schema.TypeStringArray
		case schema.TypeInet:
			return schema.TypeInetArray
		case source.TypeEmbedded:
			return source.TypeRelation
		}
	default:
		fmt.Printf("unknown %s type %s\n", s.Title, s.Type)
		return schema.TypeInvalid
	}
	fmt.Printf("unknown %s type %s\n", s.Title, s.Type)
	return schema.TypeInvalid
}
