package columns

import (
	"context"
	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

func ChangeTypeDefaultResolvers() *schema.Table {
	return &schema.Table{
		Name:     "test_columns_change_type_default_resolver",
		Resolver: fetchColumnsChangeTypeDefaultResolvers,
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
				Type:     schema.TypeJSON,
				Resolver: schema.PathResolver("Embedded.FieldA"),
			},
		},
	}
}

// ====================================================================================================================
//                                               Table Resolver Functions
// ====================================================================================================================

func fetchColumnsChangeTypeDefaultResolvers(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
