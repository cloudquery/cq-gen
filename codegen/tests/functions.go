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

func IgnoreErrorFunc(err error) bool {
	return true
}

func TestMultiplex(meta schema.ClientMeta) []schema.ClientMeta {
	return nil
}

func TestDeleteFilter(meta schema.ClientMeta, parent *schema.Resource) []interface{} {
	return nil
}
