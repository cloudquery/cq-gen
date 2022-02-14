package output

import (
	"context"

	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

func UserDefinedSimples() *schema.Table {
	return &schema.Table{
		Name:     "test_user_defined_simple",
		Resolver: fetchUserDefinedSimples,
		Columns: []schema.Column{
			{
				Name:        "test_column",
				Description: "user defined column test",
				Type:        schema.TypeJSON,
				Resolver:    ResolveUserDefinedSimpleTestColumn,
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

func fetchUserDefinedSimples(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
func ResolveUserDefinedSimpleTestColumn(ctx context.Context, meta schema.ClientMeta, resource *schema.Resource, c schema.Column) error {
	panic("not implemented")
}
