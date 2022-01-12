package graphql

import (
	"fmt"
	"github.com/spf13/afero"
	"github.com/vektah/gqlparser/v2"
	"github.com/vektah/gqlparser/v2/ast"
	"strings"
)

type DescriptionSource struct {
	schema *ast.Schema
}

func NewDescriptionSource(path string) (*DescriptionSource, error) {
	f, err := afero.ReadFile(afero.NewOsFs(), path)
	if err != nil {
		return nil, fmt.Errorf("failed to read schema file: %w", err)
	}
	s, err := gqlparser.LoadSchema(&ast.Source{
		Name:    "schema",
		Input:   string(f),
		BuiltIn: false,
	})
	return &DescriptionSource{schema: s}, nil
}

func (d DescriptionSource) FindDescription(paths ...string) (string, error) {
	if len(paths) < 1 {
		return "", nil
	}

	typ, ok := d.schema.Types[paths[0]]
	if !ok {
		return "", fmt.Errorf("resource not found %s", paths)
	}
	if len(paths) == 1 {
		return typ.Description, nil
	}

	if len(paths) > 2 {
		return "", fmt.Errorf("graphql description source only supports 2 level path part [<type>, <field>]")
	}

	for _, c := range typ.Fields {
		if strings.EqualFold(c.Name, paths[1]) {
			return c.Description, nil
		}

	}
	return "", nil
}
