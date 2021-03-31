package main

import (
	"fmt"
	_ "github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs/types"
	_ "github.com/aws/aws-sdk-go-v2/service/directconnect/types"
	_ "github.com/aws/aws-sdk-go-v2/service/ecr/types"
	"github.com/cloudquery/cq-gen/codegen"
)

func main() {
	err := codegen.Generate("config.hcl")
	if err != nil {
		fmt.Println(err)
		return
	}
}
