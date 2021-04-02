module github.com/cloudquery/cq-gen

go 1.15

require (
	github.com/agext/levenshtein v1.2.3 // indirect
	github.com/aws/aws-sdk-go-v2/config v1.1.3 // indirect
	github.com/aws/aws-sdk-go-v2/service/autoscaling v1.2.0
	github.com/aws/aws-sdk-go-v2/service/cloudtrail v1.2.0
	github.com/aws/aws-sdk-go-v2/service/cloudwatch v1.2.0
	github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs v1.2.0
	github.com/aws/aws-sdk-go-v2/service/directconnect v1.2.0
	github.com/aws/aws-sdk-go-v2/service/ec2 v1.2.0
	github.com/aws/aws-sdk-go-v2/service/ecr v1.2.0
	github.com/aws/aws-sdk-go-v2/service/ecs v1.2.0
	github.com/aws/aws-sdk-go-v2/service/efs v1.2.0
	github.com/aws/aws-sdk-go-v2/service/eks v1.2.0
	github.com/aws/aws-sdk-go-v2/service/elasticbeanstalk v1.2.0
	github.com/aws/aws-sdk-go-v2/service/elasticloadbalancingv2 v1.2.0
	github.com/aws/aws-sdk-go-v2/service/emr v1.2.0
	github.com/aws/aws-sdk-go-v2/service/fsx v1.2.0 // indirect
	github.com/aws/aws-sdk-go-v2/service/iam v1.3.0 // indirect
	github.com/aws/aws-sdk-go-v2/service/redshift v1.2.0 // indirect
	github.com/aws/aws-sdk-go-v2/service/s3 v1.3.0
	github.com/aws/aws-sdk-go-v2/service/sns v1.2.0
	github.com/cloudquery/cq-provider-aws v0.2.17
	github.com/cloudquery/cq-provider-sdk v0.0.0-20210401093836-ce64599334b2
	github.com/creasty/defaults v1.5.1
	github.com/fatih/color v1.10.0 // indirect
	github.com/google/go-cmp v0.5.5 // indirect
	github.com/hashicorp/go-hclog v0.15.0
	github.com/hashicorp/hcl/v2 v2.9.1
	github.com/iancoleman/strcase v0.1.3
	github.com/jackc/pgx/v4 v4.11.0 // indirect
	github.com/jinzhu/inflection v1.0.0
	github.com/mitchellh/go-wordwrap v1.0.1 // indirect
	github.com/modern-go/reflect2 v1.0.1
	github.com/pkg/errors v0.9.1
	github.com/serenize/snaker v0.0.0-20201027110005-a7ad2135616e
	github.com/shopspring/decimal v1.2.0 // indirect
	github.com/zclconf/go-cty v1.8.1 // indirect
	golang.org/x/mod v0.4.2 // indirect
	golang.org/x/sync v0.0.0-20210220032951-036812b2e83c // indirect
	golang.org/x/sys v0.0.0-20210331175145-43e1dd70ce54 // indirect
	golang.org/x/tools v0.1.0
	gopkg.in/yaml.v3 v3.0.0-20210107192922-496545a6307b // indirect

)

replace github.com/cloudquery/cq-provider-aws => ./providers/cq-provider-aws
