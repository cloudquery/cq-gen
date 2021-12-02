module github.com/cloudquery/cq-gen

go 1.15

require (
	github.com/aws/aws-sdk-go-v2/service/acm v1.9.1 // indirect
	github.com/aws/aws-sdk-go-v2/service/dynamodb v1.10.0
	github.com/aws/aws-sdk-go-v2/service/ec2 v1.16.0 // indirect
	github.com/aws/aws-sdk-go-v2/service/route53domains v1.6.0 // indirect
	github.com/cloudquery/cq-provider-aws v0.6.1
	github.com/cloudquery/cq-provider-azure v0.2.2
	github.com/cloudquery/cq-provider-gcp v0.3.2
	github.com/cloudquery/cq-provider-okta v0.1.1
	github.com/cloudquery/cq-provider-sdk v0.5.2
	github.com/creasty/defaults v1.5.2
	github.com/google/go-cmp v0.5.6 // indirect
	github.com/hashicorp/go-hclog v1.0.0
	github.com/hashicorp/hcl/v2 v2.10.1
	github.com/iancoleman/strcase v0.2.0
	github.com/jinzhu/inflection v1.0.0
	github.com/modern-go/reflect2 v1.0.2
	github.com/pkg/errors v0.9.1
	golang.org/x/tools v0.1.5
)

// Note: add replace for your local provider so cq-gen rewriter will work properlly
//github.com/cloudquery/cq-provider-azure => ../cq-provider-azure
//github.com/cloudquery/cq-provider-gcp => ../cq-provider-gcp
replace github.com/cloudquery/cq-provider-aws => ../cq-provider-aws
