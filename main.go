package main

import (
	"fmt"
	"github.com/cloudquery/cq-gen/codegen"
	_ "github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs/types"
	_ "github.com/aws/aws-sdk-go-v2/service/directconnect/types"
)

func main() {
	err := codegen.Generate("config.hcl")
	if err != nil {
		fmt.Println(err)
		return
	}
}
