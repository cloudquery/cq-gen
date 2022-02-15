package config

import (
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/gohcl"
)

func decodeResourceBlock(ctx *hcl.EvalContext, block *hcl.Block) (*ResourceConfig, hcl.Diagnostics) {
	return decodeResourceBody(ctx, block.Body, block.Labels)
}

func decodeResourceBody(ctx *hcl.EvalContext, body hcl.Body, labels []string) (*ResourceConfig, hcl.Diagnostics) {
	content, diags := body.Content(resourceBlockSchema)
	if diags != nil {
		return nil, diags
	}
	resource := &ResourceConfig{
		Service: labels[0],
		Domain:  labels[1],
		Name:    labels[2],
	}
	if attr, exists := content.Attributes["path"]; exists {
		diags = append(diags, gohcl.DecodeExpression(attr.Expr, ctx, &resource.Path)...)
	}
	if attr, exists := content.Attributes["allow_unexported"]; exists {
		diags = append(diags, gohcl.DecodeExpression(attr.Expr, ctx, &resource.AllowUnexported)...)
	}
	if attr, exists := content.Attributes["description"]; exists {
		diags = append(diags, gohcl.DecodeExpression(attr.Expr, ctx, &resource.Description)...)
	}
	if attr, exists := content.Attributes["limit_depth"]; exists {
		diags = append(diags, gohcl.DecodeExpression(attr.Expr, ctx, &resource.LimitDepth)...)
	}
	if attr, exists := content.Attributes["disable_auto_descriptions"]; exists {
		diags = append(diags, gohcl.DecodeExpression(attr.Expr, ctx, &resource.DisableReadDescriptions)...)
	}
	if attr, exists := content.Attributes["disable_pluralize"]; exists {
		diags = append(diags, gohcl.DecodeExpression(attr.Expr, ctx, &resource.NoPluralize)...)
	}
	if attr, exists := content.Attributes["description_path_parts"]; exists {
		diags = append(diags, gohcl.DecodeExpression(attr.Expr, ctx, &resource.DescriptionPathParts)...)
	}
	for _, b := range content.Blocks {
		switch b.Type {
		case "column":
			c := ColumnConfig{Name: b.Labels[0]}
			diags = append(diags, gohcl.DecodeBody(b.Body, ctx, &c)...)
			if diags.HasErrors() {
				continue
			}
			resource.Columns = append(resource.Columns, c)
		case "userDefinedColumn":
			c := ColumnConfig{Name: b.Labels[0]}
			diags = append(diags, gohcl.DecodeBody(b.Body, ctx, &c)...)
			if diags.HasErrors() {
				continue
			}
			resource.UserDefinedColumn = append(resource.UserDefinedColumn, c)
		case "ignoreError":
			f := FunctionConfig{Name: b.Labels[0]}
			diags = append(diags, gohcl.DecodeBody(b.Body, ctx, &f)...)
			if diags.HasErrors() {
				continue
			}
			resource.IgnoreError = &f
		case "multiplex":
			f := FunctionConfig{Name: b.Labels[0]}
			diags = append(diags, gohcl.DecodeBody(b.Body, ctx, &f)...)
			if diags.HasErrors() {
				continue
			}
			resource.Multiplex = &f
		case "postResourceResolver":
			f := FunctionConfig{Name: b.Labels[0]}
			diags = append(diags, gohcl.DecodeBody(b.Body, ctx, &f)...)
			if diags.HasErrors() {
				continue
			}
			resource.PostResourceResolver = &f
		case "deleteFilter":
			f := FunctionConfig{Name: b.Labels[0]}
			diags = append(diags, gohcl.DecodeBody(b.Body, ctx, &f)...)
			if diags.HasErrors() {
				continue
			}
			resource.DeleteFilter = &f
		case "resolver":
			f := FunctionConfig{Name: b.Labels[0]}
			diags = append(diags, gohcl.DecodeBody(b.Body, ctx, &f)...)
			if diags.HasErrors() {
				continue
			}
			resource.Resolver = &f
		case "relation":
			rel, relDiags := decodeRelationBlock(ctx, b)
			diags = append(diags, relDiags...)
			if rel == nil {
				continue
			}
			resource.Relations = append(resource.Relations, *rel)
		case "user_relation":
			rel, relDiags := decodeRelationBlock(ctx, b)
			diags = append(diags, relDiags...)
			if rel == nil {
				continue
			}
			resource.UserRelations = append(resource.UserRelations, *rel)

		case "options":
			f := TableOptionsConfig{}
			diags = append(diags, gohcl.DecodeBody(b.Body, ctx, &f)...)
			if diags.HasErrors() {
				continue
			}
			resource.TableOptions = &f
		default:
			// Should never happen because the above cases should be exhaustive
			// for all block type names in our schema.
			continue
		}
	}
	return resource, diags
}

func decodeRelationBlock(ctx *hcl.EvalContext, block *hcl.Block) (*RelationConfig, hcl.Diagnostics) {
	content, body, diags := block.Body.PartialContent(relationBlockSchema)
	if diags.HasErrors() {
		return nil, diags
	}
	resource, diags := decodeResourceBody(ctx, body, block.Labels)
	if diags.HasErrors() {
		return nil, diags
	}
	rel := &RelationConfig{
		ResourceConfig: *resource,
		Rename:         "",
		Embed:          false,
		SkipPrefix:     false,
	}

	if attr, exists := content.Attributes["skip_prefix"]; exists {
		diags = append(diags, gohcl.DecodeExpression(attr.Expr, ctx, &rel.SkipPrefix)...)
	}
	if attr, exists := content.Attributes["embed"]; exists {
		diags = append(diags, gohcl.DecodeExpression(attr.Expr, ctx, &rel.Embed)...)
	}
	if attr, exists := content.Attributes["rename"]; exists {
		diags = append(diags, gohcl.DecodeExpression(attr.Expr, ctx, &rel.Rename)...)
	}
	return rel, diags
}

var (
	relationBlockSchema = &hcl.BodySchema{
		Attributes: []hcl.AttributeSchema{
			{
				Name:     "skip_prefix",
				Required: false,
			},
			{
				Name:     "embed",
				Required: false,
			},
			{
				Name:     "rename",
				Required: false,
			},
		},
	}
	resourceBlockSchema = &hcl.BodySchema{
		Attributes: []hcl.AttributeSchema{
			{
				Name:     "description",
				Required: false,
			},
			{
				Name:     "path",
				Required: false,
			},
			{
				Name:     "limit_depth",
				Required: false,
			},
			{
				Name:     "disable_auto_descriptions",
				Required: false,
			},
			{
				Name:     "disable_pluralize",
				Required: false,
			},
			{
				Name:     "description_path_parts",
				Required: false,
			},
			{
				Name:     "allow_unexported",
				Required: false,
			},
		},
		Blocks: []hcl.BlockHeaderSchema{
			{
				Type:       "options",
				LabelNames: []string{},
			},
			{
				Type:       "column",
				LabelNames: []string{"name"},
			},
			{
				Type:       "userDefinedColumn",
				LabelNames: []string{"name"},
			},
			{
				Type:       "relation",
				LabelNames: []string{"service", "domain", "name"},
			},
			{
				Type:       "user_relation",
				LabelNames: []string{"service", "domain", "name"},
			},
			{
				Type:       "ignoreError",
				LabelNames: []string{"name"},
			},
			{
				Type:       "multiplex",
				LabelNames: []string{"name"},
			},
			{
				Type:       "deleteFilter",
				LabelNames: []string{"name"},
			},
			{
				Type:       "postResourceResolver",
				LabelNames: []string{"name"},
			},
			{
				Type:       "resolver",
				LabelNames: []string{"name"},
			},
		},
	}
)
