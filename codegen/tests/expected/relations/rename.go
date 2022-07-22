package relations

import (
	"context"

	"github.com/cloudquery/cq-gen/codegen/tests"
	"github.com/cloudquery/cq-provider-sdk/helpers"
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

func Rename() *schema.Table {
	return &schema.Table{
		Name:          "test_relations_rename",
		Resolver:      fetchRelationsRename,
		IgnoreInTests: true,
		Columns: []schema.Column{
			{
				Name: "column",
				Type: schema.TypeBigInt,
			},
		},
		Relations: []*schema.Table{
			{
				Name:          "test_base_renamed",
				Resolver:      fetchBaseRenamed,
				IgnoreInTests: true,
				Columns: []schema.Column{
					{
						Name:        "rename_cq_id",
						Description: "Unique CloudQuery ID of test_relations_rename table (FK)",
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
	}
}

// ====================================================================================================================
//                                               Table Resolver Functions
// ====================================================================================================================

func fetchRelationsRename(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
func fetchBaseRenamed(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	// This is a generated base implementation. You may edit it if necessary.
	p := helpers.ToPointer(parent.Item).(*tests.SimpleRelation)
	res <- p.Relations
	return nil
}
