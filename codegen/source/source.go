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
	return &UserDescriptionParser{
		regex:        regexp.MustCompile(regex),
		replaceWords: words,
	}
}

func (p *UserDescriptionParser) Parse(description string) string {
	match := p.regex.FindStringSubmatch(description)
	if len(match) == 0 {
		return description
	}
	paramsMap := make(map[string]string)
	for i, name := range p.regex.SubexpNames() {
		if i > 0 && i <= len(match) {
			paramsMap[name] = match[i]
		}
	}
	description, ok := paramsMap["description"]
	if !ok {
		return description
	}
	// remove possible values
	for _, replace := range p.replaceWords {
		description = strings.ReplaceAll(description, replace, "")
	}
	return strings.TrimSpace(strings.ReplaceAll(strings.ReplaceAll(description, ".", ""), "\n", " "))
}
