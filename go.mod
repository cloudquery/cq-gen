module github.com/cloudquery/cq-gen

go 1.15

require (
	github.com/aws/aws-sdk-go-v2/service/cloudwatch v1.2.0 // indirect
	github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs v1.1.2
	github.com/aws/aws-sdk-go-v2/service/directconnect v1.1.2
	github.com/cloudquery/cloudquery-plugin-sdk v0.0.0
	github.com/cloudquery/cq-provider-aws v0.2.16
	github.com/creasty/defaults v1.5.1
	github.com/google/go-cmp v0.5.4 // indirect
	github.com/hashicorp/go-hclog v0.15.0
	github.com/hashicorp/hcl/v2 v2.9.1
	github.com/iancoleman/strcase v0.1.2
	github.com/jinzhu/inflection v1.0.0
	github.com/modern-go/reflect2 v1.0.1
	github.com/pkg/errors v0.9.1
	github.com/shopspring/decimal v1.2.0 // indirect
	golang.org/x/mod v0.4.0 // indirect
	golang.org/x/sys v0.0.0-20210124154548-22da62e12c0c // indirect
	golang.org/x/tools v0.1.0
	gopkg.in/yaml.v3 v3.0.0-20210107192922-496545a6307b // indirect

)

replace github.com/cloudquery/cloudquery-plugin-sdk => ../cloudquery-plugin-sdk

replace github.com/cloudquery/cq-provider-aws => ./providers/cq-provider-aws
