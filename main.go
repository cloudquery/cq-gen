package main

import (
	"flag"
	"fmt"

	"github.com/cloudquery/cq-gen/codegen"
	//_ "github.com/cloudquery/cq-provider-aws/resources"
	//_ "github.com/cloudquery/cq-provider-azure/resources"
	//_ "github.com/cloudquery/cq-provider-digitalocean/resources"
	//_ "github.com/cloudquery/cq-provider-gcp/resources"
	//_ "github.com/cloudquery/cq-provider-okta/resources"
	_ "github.com/cloudquery/cq-provider-k8s/resources"
)

func main() {
	resource := flag.String("resource", "", "resource name to generate")
	domain := flag.String("domain", "", "domain of resource to generate")
	config := flag.String("config", "config.hcl", "resource name to generate")
	flag.Parse()

	fmt.Println("Starting code generation")
	if err := codegen.Generate(*config, *domain, *resource); err != nil {
		fmt.Println(err)
		return
	}
}
