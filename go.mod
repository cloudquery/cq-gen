module github.com/cloudquery/cq-gen

go 1.16

require (
	github.com/cloudquery/cq-provider-aws v0.0.0-00010101000000-000000000000
	github.com/cloudquery/cq-provider-sdk v0.5.7
	github.com/creasty/defaults v1.5.2
	github.com/getkin/kin-openapi v0.83.0
	github.com/hashicorp/go-hclog v1.0.0
	github.com/hashicorp/hcl/v2 v2.10.1
	github.com/iancoleman/strcase v0.2.0
	github.com/jinzhu/inflection v1.0.0
	github.com/modern-go/reflect2 v1.0.2
	github.com/pkg/errors v0.9.1
	github.com/stretchr/testify v1.7.0
	golang.org/x/tools v0.1.5
)

replace github.com/cloudquery/cq-provider-aws => ../cq-provider-aws
