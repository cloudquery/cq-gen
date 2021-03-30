package codegen

import (
	"github.com/cloudquery/cloudquery-plugin-sdk/plugin/schema"
	"go/types"
)

type TableDefinition struct {
	OriginalName string
	TypeName     string
	Name         string
	Description  string
	Columns      []ColumnDefinition
	Relations    []*TableDefinition
	// schema.TableResolver definition
	Resolver *FunctionDefinition
	// Table extra functions
	IgnoreErrorFunc  *FunctionDefinition
	MultiplexFunc    *FunctionDefinition
	DeleteFilterFunc *FunctionDefinition

	// Functions that were created by configuration request
	Functions []*FunctionDefinition
}

func (t TableDefinition) UniqueResolvers() []*FunctionDefinition {

	rd := make([]*FunctionDefinition, 0)
	rd = append(rd, t.Resolver)
	existingResolvers := make(map[string]bool)

	for _, f := range t.Functions {
		if _, ok := existingResolvers[f.Name]; ok {
			continue
		}
		rd = append(rd, f)
		existingResolvers[f.Name] = true
	}

	for _, relation := range t.Relations {
		for _, ur := range relation.UniqueResolvers() {
			if _, ok := existingResolvers[ur.Name]; ok {
				continue
			}
			rd = append(rd, ur)
			existingResolvers[ur.Name] = true
		}
	}
	return rd
}

func (t TableDefinition) RelationExists(name string) bool {
	for _, rel := range t.Relations {
		if rel.OriginalName == name {
			return true
		}
	}
	return false
}

type ColumnDefinition struct {
	Name        string
	Type        schema.ValueType
	Description string
	Resolver    *FunctionDefinition
}

type FunctionDefinition struct {
	Name      string
	Signature string
	Body      string
	Type      types.Object
	Arguments string
}
