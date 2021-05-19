module github.com/cloudquery/cq-gen

go 1.15

require (
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
	github.com/aws/aws-sdk-go-v2/service/elasticloadbalancing v1.3.0
	github.com/aws/aws-sdk-go-v2/service/elasticloadbalancingv2 v1.2.0
	github.com/aws/aws-sdk-go-v2/service/emr v1.2.0
	github.com/aws/aws-sdk-go-v2/service/iam v1.3.0
	github.com/aws/aws-sdk-go-v2/service/lambda v1.3.0
	github.com/aws/aws-sdk-go-v2/service/route53 v1.4.0
	github.com/aws/aws-sdk-go-v2/service/s3 v1.5.0
	github.com/aws/aws-sdk-go-v2/service/sns v1.2.0
	github.com/cloudquery/cq-provider-aws v0.3.13
	github.com/cloudquery/cq-provider-sdk v0.2.0
	github.com/creasty/defaults v1.5.1
	github.com/hashicorp/go-hclog v0.16.1
	github.com/hashicorp/hcl/v2 v2.10.0
	github.com/iancoleman/strcase v0.1.3
	github.com/jinzhu/inflection v1.0.0
	github.com/modern-go/reflect2 v1.0.1
	github.com/pkg/errors v0.9.1
	golang.org/x/mod v0.4.2 // indirect
	golang.org/x/tools v0.1.0
)

replace github.com/cloudquery/cq-provider-aws => ../cq-provider-aws

//replace github.com/cloudquery/cq-provider-gcp => ./providers/cq-provider-gcp
