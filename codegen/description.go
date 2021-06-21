package codegen

import (
	"go/ast"
	"regexp"
	"strings"
)

var azureDescriptionRegex = regexp.MustCompile(`^(?is)(?P<Column>.*? - )?(?P<Attr>.*?;)?(?P<Description>.*?)$`)

type DescriptionParser interface {
	Parse(description string) string
}

type DefaultDescriptionParser struct {
}

func (p *DefaultDescriptionParser) Parse(description string) string {
	data := strings.SplitN(description, ". ", 2)[0]
	return strings.TrimSpace(strings.ReplaceAll(data, "\n", " "))
}

type AzureDescriptionParser struct{}

func (p *AzureDescriptionParser) Parse(description string) string {

	matches := azureDescriptionRegex.FindStringSubmatch(description)
	var data string

	if len(matches) == 0 {
		data = ""
	} else {
		data = matches[len(matches) -1]
	}

	return strings.TrimSpace(strings.ReplaceAll(strings.ReplaceAll(data, ".", ""), "\n", " "))
}

type GcpDescriptionParser struct{}

var gcpRegex = regexp.MustCompile("(?is)(?P<Attr>.?:.)(?P<Output>\\[?Output only\\]?\\..)?(?P<Description>.*\\.)")

func (p *GcpDescriptionParser) Parse(description string) string {
	matches := gcpRegex.FindStringSubmatch(description)
	if len(matches) == 0 {
		return ""
	}
	description = matches[3]
	// remove possible values
	if strings.HasPrefix(description, "Optional") {
		description = strings.SplitN(description, "Optional", 2)[1]
	}
	if strings.HasPrefix(description, "[Output Only]") {
		description = strings.SplitN(description, "[Output Only]", 2)[1]
	}
	if strings.HasPrefix(description, "(Optional)") {
		description = strings.SplitN(description, "(Optional)", 2)[1]
	}

	return strings.TrimSpace(strings.ReplaceAll(strings.ReplaceAll(description, ".", ""), "\n", " "))
}

func getDescriptionParser(parser string) DescriptionParser {
	switch parser {
	case "azure":
		return &AzureDescriptionParser{}
	case "gcp":
		return &GcpDescriptionParser{}
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
