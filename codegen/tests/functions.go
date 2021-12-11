package tests

import (
	"context"

	"github.com/cloudquery/cq-provider-sdk/provider/schema"
)

func TestResolver(ctx context.Context, meta schema.ClientMeta, resource *schema.Resource, c schema.Column) error {
	panic("not implemented")
}

func PathTestResolver(s string) schema.ColumnResolver {
	return TestResolver
}
