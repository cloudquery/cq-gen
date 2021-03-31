package config

import (
	"github.com/cloudquery/cq-gen/code"
	"github.com/creasty/defaults"
	"github.com/hashicorp/hcl/v2/hclsimple"
)

type Config struct {
	Service         string           `hcl:"service"`
	OutputDirectory string           `hcl:"output_directory"`
	Resources       []ResourceConfig `hcl:"resource,block"`
}

type ResourceConfig struct {
	Service string `hcl:"service,label"`
	Domain  string `hcl:"domain,label"`
	Name    string `hcl:"name,label"`
	Path    string `hcl:"path,optional"`

	Columns           []ColumnConfig   `hcl:"column,block"`
	Relations         []ResourceConfig `hcl:"relation,block"`
	UserDefinedColumn []ColumnConfig   `hcl:"userDefinedColumn,block"`

	IgnoreError          *FunctionConfig `hcl:"ignoreError,block"`
	Multiplex            *FunctionConfig `hcl:"multiplex,block"`
	DeleteFilter         *FunctionConfig `hcl:"deleteFilter,block"`
	PostResourceResolver *FunctionConfig `hcl:"postResourceResolver,block"`
}

type FunctionConfig struct {
	Name string `hcl:"name,label"`
	Body string `hcl:"body,optional"`
	Path string `hcl:"path"`
}

func (r ResourceConfig) GetRelationConfig(name string) *ResourceConfig {
	for _, r := range r.Relations {
		if r.Name == name {
			return &r

		}
		if _, typeName := code.PkgAndType(r.Path); typeName == name {
			return &r
		}
	}
	return nil
}

func (r ResourceConfig) GetColumnConfig(name string) ColumnConfig {
	for _, c := range r.Columns {
		if c.Name == name {
			return c
		}
	}
	var c ColumnConfig
	defaults.Set(&c)
	c.Name = name
	return c
}

type ColumnConfig struct {
	Name       string `hcl:"name,label"`
	SkipPrefix bool   `hcl:"skip_prefix,optional" defaults:"false"`
	Skip       bool   `hcl:"skip,optional" defaults:"false"`
	// Whether to force a resolver creation
	GenerateResolver bool `hcl:"generate_resolver,optional"`
	// Unique resolver function to use
	Resolver *FunctionConfig `hcl:"resolver,block"`
	// Override column type, use carefully, validation will fail if interface{} of value isn't the same as expected ValueType
	Type string `hcl:"type,optional"`
	// Rename column name, if no resolver is passed schema.PathResolver will be used
	Rename string `hcl:"rename,optional"`

	// Configuration to pass to inner embedded columns
	EmbeddedColumns []ColumnConfig `hcl:"embeddedColumn,block"`
}

func (c ColumnConfig) GetColumnConfig(name string) ColumnConfig {
	for _, ec := range c.EmbeddedColumns {
		if ec.Name == name {
			return c
		}
	}
	var ec ColumnConfig
	defaults.Set(&ec)
	ec.Name = name
	return ec
}

func Parse(configPath string) (*Config, error) {
	var config Config
	if err := hclsimple.DecodeFile(configPath, nil, &config); err != nil {
		return nil, err
	}
	return &config, nil
}
