module github.com/cloudquery/cq-gen

go 1.15

require (
	github.com/cloudquery/cq-provider-sdk v0.5.1
	github.com/creasty/defaults v1.5.2
	github.com/getkin/kin-openapi v0.80.0
	github.com/hashicorp/go-hclog v1.0.0
	github.com/hashicorp/hcl/v2 v2.10.1
	github.com/iancoleman/strcase v0.2.0
	github.com/jinzhu/inflection v1.0.0
	github.com/modern-go/reflect2 v1.0.2
	github.com/pkg/errors v0.9.1
	github.com/stretchr/testify v1.7.0
	golang.org/x/tools v0.1.5
)

require (
	github.com/cloudquery/cq-provider-aws v0.6.4
	golang.org/x/term v0.0.0-20210220032956-6a3ed077a48d // indirect
	golang.org/x/time v0.0.0-20210723032227-1f47c861a9ac // indirect
)

// Note: add replace for your local provider so cq-gen rewriter will work properlly
//github.com/cloudquery/cq-provider-azure => ../cq-provider-azure
//replace github.com/cloudquery/cq-provider-k8s => ../cq-provider-k8s
replace github.com/cloudquery/cq-provider-aws => ../cq-provider-aws
