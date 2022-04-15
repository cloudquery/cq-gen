package codegen

import (
	"go/types"
	"strings"

	"github.com/zclconf/go-cty/cty"

	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
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
	path        string
}

func (t TableDefinition) UniqueResolvers() []*ResolverDefinition {

	rd := make([]*ResolverDefinition, 0)
	existingResolvers := make(map[string]bool)
	for _, f := range t.Functions {
		if !f.Generate {
			continue
		}
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

func (t TableDefinition) RelationExists(cfg config.RelationConfig) bool {
	for _, rel := range t.Relations {
		if rel.Name == cfg.Name {
			return true
		}
		if rel.Name == cfg.Rename {
			return true
		}
		if strings.HasSuffix(rel.TableFuncName, cfg.Name) {
			return true
		}
		if strings.HasSuffix(rel.TableName, cfg.Name) {
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
	Generate  bool
	Params    []cty.Value
}
