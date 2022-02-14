package output

import (
	"context"

	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

func RelationsUserRelations() *schema.Table {
	return &schema.Table{
		Name:     "test_relations_user_relation",
		Resolver: fetchRelationsUserRelations,
		Columns: []schema.Column{
			{
				Name: "column",
				Type: schema.TypeBigInt,
			},
		},
		Relations: []*schema.Table{
			{
				Name:     "test_relations_user_relation_relations",
				Resolver: fetchRelationsUserRelationRelations,
				Columns: []schema.Column{
					{
						Name:        "user_relation_cq_id",
						Description: "Unique CloudQuery ID of test_relations_user_relation table (FK)",
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
				Name:     "test_relations_user_relation_user",
				Resolver: fetchBaseUserRelationUser,
				Columns: []schema.Column{
					{
						Name:        "user_relation_cq_id",
						Description: "Unique CloudQuery ID of test_relations_user_relation table (FK)",
						Type:        schema.TypeUUID,
						Resolver:    schema.ParentIdResolver,
					},
					{
						Name: "other_field",
						Type: schema.TypeBigInt,
					},
				},
			},
			{
				Name:     "test_relations_user_relation_custom",
				Resolver: fetchBaseUserRelationCustoms,
				Columns: []schema.Column{
					{
						Name:        "user_relation_cq_id",
						Description: "Unique CloudQuery ID of test_relations_user_relation table (FK)",
						Type:        schema.TypeUUID,
						Resolver:    schema.ParentIdResolver,
					},
					{
						Name:        "test_column",
						Description: "user defined column test",
						Type:        schema.TypeJSON,
						Resolver:    ResolveBaseUserRelationCustomTestColumn,
					},
				},
			},
		},
	}
}

// ====================================================================================================================
//                                               Table Resolver Functions
// ====================================================================================================================

func fetchRelationsUserRelations(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
func fetchRelationsUserRelationRelations(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
func fetchBaseUserRelationUser(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
func fetchBaseUserRelationCustoms(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
func ResolveBaseUserRelationCustomTestColumn(ctx context.Context, meta schema.ClientMeta, resource *schema.Resource, c schema.Column) error {
	panic("not implemented")
}
