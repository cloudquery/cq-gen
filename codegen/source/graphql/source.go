package graphql

import (
	"fmt"

	"github.com/cloudquery/cq-gen/codegen/source"
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
	"github.com/spf13/afero"
	"github.com/vektah/gqlparser/v2"
	"github.com/vektah/gqlparser/v2/ast"
)

// DataSource of openapi reads objects from openapi spec
type DataSource struct {
	schema *ast.Schema
}

// TODO: WIP
func NewGraphQLSource(path string) (*DataSource, error) {
	f, err := afero.ReadFile(afero.NewOsFs(), path)
	if err != nil {
		return nil, fmt.Errorf("failed to read schema file: %w", err)
	}
	s, gqlErr := gqlparser.LoadSchema(&ast.Source{
		Name:    "schema",
		Input:   string(f),
		BuiltIn: false,
	})
	if gqlErr != nil {
		return nil, err
	}
	return &DataSource{schema: s}, nil
}

func (d DataSource) Find(path string) (source.Object, error) {

	def, ok := d.schema.Types[path]
	if !ok {
		return nil, fmt.Errorf("resource not found %s", path)
	}
	return &Object{name: path, schema: d.schema, def: def, parent: nil}, nil
}

type Object struct {
	name   string
	schema *ast.Schema
	def    *ast.Definition

	parent *Object
}

func (o Object) Name() string {
	return o.def.Name
}

func (o Object) Description() string {
	return o.def.Description
}

func (o Object) Fields() []source.Object {
	return nil
}

func (o Object) Type() schema.ValueType {
	return schema.TypeJSON
}

func (o Object) Parent() source.Object {
	return o.parent
}

func (o Object) Path() string {
	return o.def.Name
}

func GetType(a *ast.Type) *ast.Type {
	if a.Elem != nil {
		return GetType(a.Elem)
	}
	return a
}
