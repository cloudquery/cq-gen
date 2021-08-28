package codegen

import (
	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
	"go/types"
	"strings"
)

type TableDefinition struct {
	Name          string
	FileName      string
	TableFuncName string
	TableName     string
	Description   string
	Columns       []ColumnDefinition
	Relations     []*TableDefinition
	// schema.TableResolver definition
	Resolver *ResolverDefinition
	// Table extra functions
	IgnoreErrorFunc      *ResolverDefinition
	MultiplexFunc        *ResolverDefinition
	DeleteFilterFunc     *ResolverDefinition
	PostResourceResolver *ResolverDefinition

	// Table Creation Options
	Options *config.TableOptionsConfig

	// Functions that were created by configuration request
	Functions []*ResolverDefinition

	// parent table definition
	parentTable *TableDefinition
}

func (t TableDefinition) UniqueResolvers() []*ResolverDefinition {

	rd := make([]*ResolverDefinition, 0)
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
		if rel.Name == name {
			return true
		}
		if strings.HasSuffix(rel.TableFuncName, name) {
			return true
		}
		if strings.HasSuffix(rel.TableName, name) {
			return true
		}
	}
	return false
}

type ColumnDefinition struct {
	Name        string
	Type        schema.ValueType
	Description string
	Resolver    *ResolverDefinition
}

type ResolverDefinition struct {
	Name      string
	Signature string
	Body      string
	Type      types.Object
	Arguments string
}
