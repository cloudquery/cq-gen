package user_defined

import (
	"context"

	"github.com/cloudquery/cq-gen/codegen/tests"
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

func Resolvers() *schema.Table {
	return &schema.Table{
		Name:     "test_user_defined_resolvers",
		Resolver: fetchUserDefinedResolvers,
		Columns: []schema.Column{
			{
				Name:        "test_column_with_resolver",
				Description: "user defined column resolver test",
				Type:        schema.TypeJSON,
				Resolver:    tests.TestResolver,
			},
			{
				Name:        "test_column_path_resolver",
				Description: "user defined column path resolver test",
				Type:        schema.TypeInt,
				Resolver:    tests.PathTestResolver("TestColumnPathResolver"),
			},
			{
				Name:        "test_column_templated",
				Description: "user defined column test",
				Type:        schema.TypeJSON,
				Resolver:    ResolveUserDefinedResolverTestColumnTemplated,
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
	}
}

// ====================================================================================================================
//                                               Table Resolver Functions
// ====================================================================================================================

func fetchUserDefinedResolvers(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
func ResolveUserDefinedResolverTestColumnTemplated(ctx context.Context, meta schema.ClientMeta, resource *schema.Resource, c schema.Column) error {
	panic("test body")
}
