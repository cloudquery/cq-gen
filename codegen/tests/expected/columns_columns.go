package output

import (
	"context"

	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

func ColumnsColumns() *schema.Table {
	return &schema.Table{
		Name:     "test_columns_columns",
		Resolver: fetchColumnsColumns,
		Columns: []schema.Column{
			{
				Name:        "rename_int_value",
				Description: "change description to whatever you want",
				Type:        schema.TypeString,
				Resolver:    resolveColumnsColumnsRenameIntValue,
			},
			{
				Name:        "embedded_field_a",
				Description: "change description to whatever you want",
				Type:        schema.TypeBigInt,
				Resolver:    schema.PathResolver("Embedded.FieldA"),
			},
		},
	}
}

// ====================================================================================================================
//                                               Table Resolver Functions
// ====================================================================================================================

func fetchColumnsColumns(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
func resolveColumnsColumnsRenameIntValue(ctx context.Context, meta schema.ClientMeta, resource *schema.Resource, c schema.Column) error {
	panic("not implemented")
}
