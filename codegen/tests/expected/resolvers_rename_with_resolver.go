package output

import (
	"context"

	"github.com/cloudquery/cq-gen/codegen/tests"
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

func ResolversRenameWithResolvers() *schema.Table {
	return &schema.Table{
		Name:     "test_resolvers_rename_with_resolver",
		Resolver: fetchResolversRenameWithResolvers,
		Columns: []schema.Column{
			{
				Name:     "other_value",
				Type:     schema.TypeBigInt,
				Resolver: tests.TestResolver,
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
	}
}

// ====================================================================================================================
//                                               Table Resolver Functions
// ====================================================================================================================

func fetchResolversRenameWithResolvers(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan interface{}) error {
	panic("not implemented")
}
