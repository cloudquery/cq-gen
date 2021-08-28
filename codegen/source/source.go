package source

import (
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
	"strings"
)


const (
	TypeRelation schema.ValueType = -1
	TypeEmbedded schema.ValueType = -2
	TypeUserDefined schema.ValueType = -3
)


// DataSource a data source is where the codegen reads resources to create tables from it can be from go structs, protobuf, openapi (swagger), etc'
type DataSource interface {
	Find(path string) (Object, error)
}

// Object represents a resource to transform into a table
type Object interface {
	Name() string
	Description() string
	Fields() []Object
	Type() schema.ValueType
	Parent() Object
	Path() string
}

// DescriptionSource allows to find descriptions for given types based on pathing
type DescriptionSource interface {
	FindDescription(paths ...string) (string, error)
}

// DescriptionParser parse a description string
type DescriptionParser interface {
	Parse(description string) string
}

type DefaultDescriptionParser struct {}

func (p *DefaultDescriptionParser) Parse(description string) string {
	data := strings.SplitN(description, ". ", 2)[0]
	return strings.TrimSpace(strings.ReplaceAll(data, "\n", " "))
}
