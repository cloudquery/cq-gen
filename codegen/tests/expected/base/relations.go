package base

import (
	"context"

	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

func Relations() *schema.Table {
	return &schema.Table{
		Name:     "test_base_relations",
		Resolver: fetchBaseRelations,
		Columns: []schema.Column{
			{
				Name: "int64_value",
				Type: schema.TypeBigInt,
			},
			{
				Name: "string",
				Type: schema.TypeString,
			},
			{
				Name: "string_array",
				Type: schema.TypeStringArray,
			},
			{
				Name:     "inner_embedded_string",
				Type:     schema.TypeString,
				Resolver: schema.PathResolver("Inner.EmbeddedString"),
			},
		},
		Relations: []*schema.Table{
			{
				Name:     "test_base_relation_some_bases",
				Resolver: fetchBaseRelationSomeBases,
				Columns: []schema.Column{
					{
						Name:        "relation_cq_id",
						Description: "Unique CloudQuery ID of test_base_relations table (FK)",
						Type:        schema.TypeUUID,
						Resolver:    schema.ParentIdResolver,
					},
					{
						Name: "int_value",
						Type: schema.TypeBigInt,
					},
					{
						Name: "bool_value",
						Type: schema.TypeBool,
					},
					{
						Name:     "embedded_field_a",
						Type:     schema.TypeBigInt,
						Resolver: schema.PathResolver("Embedded.FieldA"),
					},
				},
			},
			{
				Name:     "test_base_relation_inner_some_bases",
				Resolver: fetchBaseRelationInnerSomeBases,
				Columns: []schema.Column{
					{
						Name:        "relation_cq_id",
						Description: "Unique CloudQuery ID of test_base_relations table (FK)",
						Type:        schema.TypeUUID,
						Resolver:    schema.ParentIdResolver,
					},
					{
						Name: "int_value",
						Type: schema.TypeBigInt,
					},
					{
						Name: "bool_value",
						Type: schema.TypeBool,
					},
					{
						Name:     "embedded_field_a",
						Type:     schema.TypeBigInt,
						Resolver: schema.PathResolver("Embedded.FieldA"),
					},
				},
			},
			{
				Name:     "test_base_relations",
				Resolver: fetchBaseRelations,
				Columns: []schema.Column{
					{
						Name:        "relation_cq_id",
						Description: "Unique CloudQuery ID of test_base_relations table (FK)",
						Type:        schema.TypeUUID,
						Resolver:    schema.ParentIdResolver,
					},
					{
						Name: "embedded_string",
						Type: schema.TypeString,
					},
				},
				Relations: []*schema.Table{
					{
						Name:     "test_base_relation_some_bases",
						Resolver: fetchBaseRelationSomeBases,
						Columns: []schema.Column{
							{
								Name:        "relation_cq_id",
								Description: "Unique CloudQuery ID of test_base_relations table (FK)",
								Type:        schema.TypeUUID,
								Resolver:    schema.ParentIdResolver,
							},
							{
								Name: "int_value",
								Type: schema.TypeBigInt,
							},
							{
								Name: "bool_value",
								Type: schema.TypeBool,
							},
							{
								Name:     "embedded_field_a",
								Type:     schema.TypeBigInt,
								Resolver: schema.PathResolver("Embedded.FieldA"),
							},
						},
					},
				},
			},
		},
	}
}

// ====================================================================================================================
//                                               Table Resolver Functions
// ====================================================================================================================

func fetchBaseRelations(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
func fetchBaseRelationSomeBases(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
func fetchBaseRelationInnerSomeBases(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
