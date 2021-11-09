module github.com/cloudquery/cq-gen

go 1.15

require (
	github.com/aws/aws-sdk-go v1.27.0 // indirect
	github.com/cloudquery/cq-provider-aws v0.0.0-00010101000000-000000000000
	github.com/cloudquery/cq-provider-k8s v0.0.0-00010101000000-000000000000
	//github.com/cloudquery/cq-provider-okta v0.1.1
	github.com/cloudquery/cq-provider-sdk v0.5.0
	github.com/creasty/defaults v1.5.2
	github.com/hashicorp/go-hclog v1.0.0
	github.com/hashicorp/go-uuid v1.0.1 // indirect
	github.com/hashicorp/hcl/v2 v2.10.1
	github.com/iancoleman/strcase v0.2.0
	github.com/jhump/protoreflect v1.8.2 // indirect
	github.com/jinzhu/inflection v1.0.0
	github.com/modern-go/reflect2 v1.0.2
	github.com/pkg/errors v0.9.1
	golang.org/x/tools v0.1.5
)

// Note: add replace for your local provider so cq-gen rewriter will work properlly
replace (
	//github.com/cloudquery/cq-provider-azure => ../cq-provider-azure
	//github.com/cloudquery/cq-provider-gcp => ../cq-provider-gcp
	github.com/cloudquery/cq-provider-aws => ../cq-provider-aws
	github.com/cloudquery/cq-provider-k8s => ../cq-provider-k8s
)
