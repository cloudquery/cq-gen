package output

import (
	"context"

	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

func ColumnsEmbeddedRenames() *schema.Table {
	return &schema.Table{
		Name:     "test_columns_embedded_rename",
		Resolver: fetchColumnsEmbeddedRenames,
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
				Name:     "rename_prefix_field_a",
				Type:     schema.TypeBigInt,
				Resolver: schema.PathResolver("Embedded.FieldA"),
			},
		},
	}
}

// ====================================================================================================================
//                                               Table Resolver Functions
// ====================================================================================================================

func fetchColumnsEmbeddedRenames(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan interface{}) error {
	panic("not implemented")
}
