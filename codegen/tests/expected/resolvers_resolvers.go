package output

import (
	"context"

	"github.com/cloudquery/cq-gen/codegen/tests"
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

func Resolvers() *schema.Table {
	return &schema.Table{
		Name:                 "test_resolvers_resolvers",
		Resolver:             fetchResolversResolvers,
		Multiplex:            tests.TestMultiplex,
		IgnoreError:          tests.IgnoreErrorFunc,
		DeleteFilter:         tests.TestDeleteFilter,
		PostResourceResolver: GeneratedPostResolver,
		Columns: []schema.Column{
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
	}
}

// ====================================================================================================================
//                                               Table Resolver Functions
// ====================================================================================================================

func fetchResolversResolvers(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
func GeneratedPostResolver(ctx context.Context, meta schema.ClientMeta, resource *schema.Resource) error {
	panic("not implemented")
}
