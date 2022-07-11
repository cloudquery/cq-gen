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
	cfg, diags := decodeConfig(f.Body, diags)
	if diags.HasErrors() {
		return nil, diags
	}
	cfg.Path = configPath
	return cfg, diags
}

func decodeConfig(body hcl.Body, diags hcl.Diagnostics) (*Config, hcl.Diagnostics) {
	config := &Config{}
	content, contentDiags := body.Content(configFileSchema)
	diags = append(diags, contentDiags...)
	if outputDirAttr, ok := content.Attributes["output_directory"]; ok {
		diags = append(diags, gohcl.DecodeExpression(outputDirAttr.Expr, nil, &config.OutputDirectory)...)
	}
	if attr, ok := content.Attributes["service"]; ok {
		diags = append(diags, gohcl.DecodeExpression(attr.Expr, nil, &config.Service)...)
	}
	if attr, ok := content.Attributes["add_generate"]; ok {
		diags = append(diags, gohcl.DecodeExpression(attr.Expr, nil, &config.AddGenerate)...)
	}

	for _, block := range content.Blocks {
		switch block.Type {
		case "resource":
			resource, resourceDiags := decodeResourceBlock(nil, block)
			diags = append(diags, resourceDiags...)
			if resource != nil {
				config.Resources = append(config.Resources, *resource)
			}
		case "description_modifier":
			dp := DescriptionModifier{
				Name: block.Labels[0],
			}
			diags = append(diags, gohcl.DecodeBody(block.Body, nil, &dp)...)
			config.DescriptionModifiers = append(config.DescriptionModifiers, dp)
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
		{
			Name:     "add_generate",
			Required: false,
		},
	},
	Blocks: []hcl.BlockHeaderSchema{
		{
			Type:       "resource",
			LabelNames: []string{"service", "domain", "name"},
		},
		{
			Type:       "data_source",
			LabelNames: []string{"type"},
		},
		{
			Type:       "description_source",
			LabelNames: []string{"type"},
		},
		{
			Type:       "description_modifier",
			LabelNames: []string{"name"},
		},
	},
}
