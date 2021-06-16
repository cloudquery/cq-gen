package codegen

import (
	"go/ast"
	"strings"
)

type DescriptionParser interface {
	Parse(description string) string
}

type DefaultDescriptionParser struct {
}

func (p *DefaultDescriptionParser) Parse(description string) string {
	data := strings.SplitN(description, ". ", 2)[0]
	return strings.TrimSpace(strings.ReplaceAll(data, "\n", " "))
}

type AzureDescriptionParser struct {
}

func (p *AzureDescriptionParser) Parse(description string) string {
	parts := strings.SplitN(description, "; ", 2)
	var data string
	switch len(parts) {
	case 0:
		data = ""
	case 1:
		data = parts[0]
	default:
		data = parts[1]
	}
	return strings.TrimSpace(strings.ReplaceAll(strings.ReplaceAll(data, ".", ""), "\n", " "))
}

func getDescriptionParser(parser string) DescriptionParser {
	switch parser {
	case "azure":
		return &AzureDescriptionParser{}
	default:
		return &DefaultDescriptionParser{}
	}
}

func getSpecColumnDescription(parser DescriptionParser, spec *ast.TypeSpec, columnName string) string {
	s := spec.Type.(*ast.StructType)
	for _, f := range s.Fields.List {
		if f.Names == nil {
			continue
		}
		if f.Names[0].Name != columnName {
			continue
		}
		if f.Comment != nil {
			return parser.Parse(f.Comment.Text())
		}
		if f.Doc != nil {
			return parser.Parse(f.Doc.Text())
		}
	}
	return ""
}
