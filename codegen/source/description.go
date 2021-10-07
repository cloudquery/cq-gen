package source

import (
	"regexp"
	"strings"
)

// TODO: move this out of here

var azureDescriptionRegex = regexp.MustCompile(`^(?is)(?P<Column>.*? - )?(?P<Attr>.*?;)?(?P<Description>.*?)$`)

type AzureDescriptionParser struct{}

func (p *AzureDescriptionParser) Parse(description string) string {

	matches := azureDescriptionRegex.FindStringSubmatch(description)
	var data string

	if len(matches) == 0 {
		data = ""
	} else {
		data = matches[len(matches)-1]
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
	//
	prefixes := []string{"[Beta] [Optional]", "[Required]", "[TrustedTester]", "[Repeated]", "[Optional, Trusted Tester]", "[Output-only, Beta]", "[Pick one]", "[TrustedTester]", "Optional", "[Output-only]", "[Output only]","[Output Only]", "(Optional)", "[Optional]", "Required", "[Required]"}
	for _, prefix := range prefixes {
		if strings.HasPrefix(description, prefix) {
			description = strings.SplitN(description, prefix, 2)[1]
		}
	}

	return strings.TrimSpace(strings.ReplaceAll(strings.ReplaceAll(description, ".", ""), "\n", " "))
}
// TODO: move this out of here
func GetDescriptionParser(parser string) DescriptionParser {
	switch parser {
	case "azure":
		return &AzureDescriptionParser{}
	case "gcp":
		return &GcpDescriptionParser{}
	default:
		return &DefaultDescriptionParser{}
	}
}

