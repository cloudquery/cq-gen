package main

import (
	"flag"
	"fmt"
	_ "github.com/aws/aws-sdk-go-v2/service/autoscaling/types"
	_ "github.com/aws/aws-sdk-go-v2/service/cloudtrail/types"
	_ "github.com/aws/aws-sdk-go-v2/service/cloudwatch/types"
	_ "github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs/types"
	_ "github.com/aws/aws-sdk-go-v2/service/directconnect/types"
	_ "github.com/aws/aws-sdk-go-v2/service/ec2/types"
	_ "github.com/aws/aws-sdk-go-v2/service/ecr/types"
	_ "github.com/aws/aws-sdk-go-v2/service/ecs/types"
	_ "github.com/aws/aws-sdk-go-v2/service/efs/types"
	_ "github.com/aws/aws-sdk-go-v2/service/eks/types"
	_ "github.com/aws/aws-sdk-go-v2/service/elasticbeanstalk/types"
	_ "github.com/aws/aws-sdk-go-v2/service/elasticloadbalancingv2/types"
	_ "github.com/aws/aws-sdk-go-v2/service/emr/types"
	_ "github.com/aws/aws-sdk-go-v2/service/iam/types"
	_ "github.com/aws/aws-sdk-go-v2/service/s3/types"
	_ "github.com/aws/aws-sdk-go-v2/service/sns/types"
	"github.com/cloudquery/cq-gen/codegen"
	_ "github.com/cloudquery/cq-provider-aws/client"
)

func main() {

	resource := flag.String("resource", "", "resource name to generate")
	domain := flag.String("domain", "", "domain of resource to generate")
	config := flag.String("config", "config.hcl", "resource name to generate")
	flag.Parse()

	if err := codegen.Generate(*config, *domain, *resource); err != nil {
		fmt.Println(err)
		return
	}
}
