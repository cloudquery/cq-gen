package source

import (
	"regexp"
	"strings"

	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

const (
	TypeRelation    schema.ValueType = -1
	TypeEmbedded    schema.ValueType = -2
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
	Exported() bool
}

// DescriptionSource allows finding descriptions for given types based on pathing
type DescriptionSource interface {
	FindDescription(paths ...string) (string, error)
}

// DescriptionParser parse a description string
type DescriptionParser interface {
	Parse(description string) string
}

type DefaultDescriptionParser struct{}

func (p *DefaultDescriptionParser) Parse(description string) string {
	data := strings.SplitN(description, ". ", 2)[0]
	return strings.TrimSpace(strings.ReplaceAll(data, "\n", " "))
}

type UserDescriptionParser struct {
	regex        *regexp.Regexp
	replaceWords []string
}

func NewUserDescriptionParser(regex string, words []string) *UserDescriptionParser {
	parser := &UserDescriptionParser{
		replaceWords: words,
	}
	if regex != "" {
		parser.regex = regexp.MustCompile(regex)
	}
	return parser
}

func (p *UserDescriptionParser) Parse(description string) string {
	if p.regex != nil {
		description = p.regex.ReplaceAllString(description, "")
	}

	// remove possible values
	for _, replace := range p.replaceWords {
		description = strings.ReplaceAll(description, replace, "")
	}
	return strings.TrimSpace(strings.ReplaceAll(strings.ReplaceAll(description, ".", ""), "\n", " "))
}
