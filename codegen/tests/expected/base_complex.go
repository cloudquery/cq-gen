package output

import (
	"context"

	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

func Complexes() *schema.Table {
	return &schema.Table{
		Name:        "test_base_complex",
		Description: "ComplexStruct written descriptions on structs are show as descriptions in the table",
		Resolver:    fetchBaseComplexes,
		Columns: []schema.Column{
			{
				Name: "int_value",
				Type: schema.TypeBigInt,
			},
			{
				Name: "int8_value",
				Type: schema.TypeSmallInt,
			},
			{
				Name: "int16_value",
				Type: schema.TypeSmallInt,
			},
			{
				Name: "int32_value",
				Type: schema.TypeInt,
			},
			{
				Name: "int64_value",
				Type: schema.TypeBigInt,
			},
			{
				Name: "string",
				Type: schema.TypeString,
			},
			{
				Name: "string_array",
				Type: schema.TypeStringArray,
			},
			{
				Name: "bool_value",
				Type: schema.TypeBool,
			},
			{
				Name:        "json",
				Description: "Comments written as descriptions on fields are show as descriptions",
				Type:        schema.TypeJSON,
			},
		},
	}
}

// ====================================================================================================================
//                                               Table Resolver Functions
// ====================================================================================================================

func fetchBaseComplexes(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("not implemented")
}
