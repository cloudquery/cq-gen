package resolvers

import (
	"context"
	"github.com/cloudquery/cq-gen/codegen/tests"
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

func WithParams() *schema.Table {
	return &schema.Table{
		Name:     "test_resolvers_with_params",
		Resolver: fetchResolversWithParams,
		Columns: []schema.Column{
			{
				Name:     "test",
				Type:     schema.TypeInvalid,
				Resolver: tests.PathTestResolver("test"),
			},
			{
				Name:     "int_value",
				Type:     schema.TypeBigInt,
				Resolver: tests.PathTestResolver("test"),
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

func fetchResolversWithParams(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
