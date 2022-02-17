package output

import (
	"context"

	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

func UserDefineds() *schema.Table {
	return &schema.Table{
		Name:     "test_resolvers_user_defined",
		Resolver: fetchUserDefined,
		Columns:  []schema.Column{},
	}
}

// ====================================================================================================================
//                                               Table Resolver Functions
// ====================================================================================================================

func fetchUserDefined(ctx context.Context, meta schema.ClientMeta, parent *schema.Resource, res chan<- interface{}) error {
	panic("my fetch implementation")
}
