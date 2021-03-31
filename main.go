package main

import (
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
	_ "github.com/aws/aws-sdk-go-v2/service/elasticbeanstalk/types"
	_ "github.com/aws/aws-sdk-go-v2/service/elasticloadbalancingv2/types"
	_ "github.com/aws/aws-sdk-go-v2/service/s3/types"
	"github.com/cloudquery/cq-gen/codegen"
)

func main() {
	err := codegen.Generate("config.hcl")
	if err != nil {
		fmt.Println(err)
		return
	}
}
