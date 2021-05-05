module github.com/cloudquery/cq-gen

go 1.15

require (
	github.com/agext/levenshtein v1.2.3 // indirect
	github.com/aws/aws-sdk-go-v2/service/autoscaling v1.2.0
	github.com/aws/aws-sdk-go-v2/service/cloudfront v1.3.0
	github.com/aws/aws-sdk-go-v2/service/cloudtrail v1.2.0
	github.com/aws/aws-sdk-go-v2/service/cloudwatch v1.2.0
	github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs v1.2.0
	github.com/aws/aws-sdk-go-v2/service/directconnect v1.2.0
	github.com/aws/aws-sdk-go-v2/service/ec2 v1.2.0
	github.com/aws/aws-sdk-go-v2/service/ecr v1.2.0
	github.com/aws/aws-sdk-go-v2/service/ecs v1.2.0
	github.com/aws/aws-sdk-go-v2/service/efs v1.2.0
	github.com/aws/aws-sdk-go-v2/service/eks v1.2.1
	github.com/aws/aws-sdk-go-v2/service/elasticbeanstalk v1.2.0
	github.com/aws/aws-sdk-go-v2/service/elasticloadbalancingv2 v1.2.0
	github.com/aws/aws-sdk-go-v2/service/emr v1.2.0
	github.com/aws/aws-sdk-go-v2/service/iam v1.3.0
	github.com/aws/aws-sdk-go-v2/service/route53 v1.4.0
	github.com/aws/aws-sdk-go-v2/service/s3 v1.5.0
	github.com/aws/aws-sdk-go-v2/service/sns v1.2.0
	github.com/cloudquery/cq-provider-aws v0.3.13
	github.com/cloudquery/cq-provider-sdk v0.1.7
	github.com/creasty/defaults v1.5.1
	github.com/fatih/color v1.10.0 // indirect
	github.com/hashicorp/go-hclog v0.16.0
	github.com/hashicorp/hcl/v2 v2.9.1
	github.com/iancoleman/strcase v0.1.3
	github.com/jackc/pgx/v4 v4.11.0 // indirect
	github.com/jinzhu/inflection v1.0.0
	github.com/mitchellh/go-wordwrap v1.0.1 // indirect
	github.com/modern-go/reflect2 v1.0.1
	github.com/pkg/errors v0.9.1
	github.com/shopspring/decimal v1.2.0 // indirect
	github.com/zclconf/go-cty v1.8.1 // indirect
	golang.org/x/mod v0.4.2 // indirect
	golang.org/x/sync v0.0.0-20210220032951-036812b2e83c // indirect
	golang.org/x/sys v0.0.0-20210403161142-5e06dd20ab57 // indirect
	golang.org/x/tools v0.1.0
)

replace github.com/cloudquery/cq-provider-aws => ../cq-provider-aws

//replace github.com/cloudquery/cq-provider-gcp => ./providers/cq-provider-gcp
