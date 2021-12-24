package config

import (
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/gohcl"
	"github.com/hashicorp/hcl/v2/hclparse"
)

func ParseConfiguration(configPath string) (*Config, hcl.Diagnostics) {
	parser := hclparse.NewParser()
	f, diags := parser.ParseHCLFile(configPath)
	if f == nil {
		return nil, diags
	}
	return decodeConfig(f.Body, diags)
}

func decodeConfig(body hcl.Body, diags hcl.Diagnostics) (*Config, hcl.Diagnostics) {
	config := &Config{}
	content, contentDiags := body.Content(configFileSchema)
	diags = append(diags, contentDiags...)
	if attr, exists := content.Attributes["service"]; exists {
		diags = append(diags, gohcl.DecodeExpression(attr.Expr, nil, &config.Service)...)
	}
	if attr, exists := content.Attributes["output_directory"]; exists {
		diags = append(diags, gohcl.DecodeExpression(attr.Expr, nil, &config.OutputDirectory)...)
	}
	for _, block := range content.Blocks {
		switch block.Type {
		case "resource":
			resource, resourceDiags := decodeResourceBlock(nil, block)
			diags = append(diags, resourceDiags...)
			if resource != nil {
				config.Resources = append(config.Resources, *resource)
			}
		case "description_parser":
			dp := DescriptionParser{
				Name: block.Labels[0],
			}
			diags = append(diags, gohcl.DecodeBody(block.Body, nil, &dp)...)
			config.DescriptionParsers = append(config.DescriptionParsers, dp)
		case "description_source":
			ds := DescriptionSource{
				Type: block.Labels[0],
			}
			diags = append(diags, gohcl.DecodeBody(block.Body, nil, &ds)...)
			config.DescriptionSource = &ds
		case "data_source":
			ds := DataSource{
				Type: block.Labels[0],
			}
			diags = append(diags, gohcl.DecodeBody(block.Body, nil, &ds)...)
			config.DataSource = &ds
		default:
			// Should never happen because the above cases should be exhaustive
			// for all block type names in our schema.
			continue
		}
	}
	return config, diags
}

// configFileSchema is the schema for the top-level of a config file. We use
// the low-level HCL API for this level so we can easily deal with each
// block type separately with its own decoding logic.
var configFileSchema = &hcl.BodySchema{
	Attributes: []hcl.AttributeSchema{
		{
			Name:     "service",
			Required: false,
		},
		{
			Name:     "output_directory",
			Required: false,
		},
	},
	Blocks: []hcl.BlockHeaderSchema{
		{
			Type:       "resource",
			LabelNames: []string{"service", "domain", "name"},
		},
	},
}
