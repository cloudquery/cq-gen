package main

import (
	"flag"
	"fmt"
	_ "github.com/aws/aws-sdk-go-v2/service/iam"
	"github.com/cloudquery/cq-gen/codegen"
	_ "github.com/cloudquery/cq-provider-aws/resources"
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
