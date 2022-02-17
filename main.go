package main

import (
	"flag"
	"fmt"

	"github.com/cloudquery/cq-gen/codegen"
	_ "github.com/cloudquery/cq-provider-azure/resources/services/compute"
)

func main() {
	resource := flag.String("resource", "", "resource name to generate")
	domain := flag.String("domain", "", "domain of resource to generate")
	config := flag.String("config", "config.hcl", "resource name to generate")
	outputDir := flag.String("output", "", "directory to output resource files to")
	flag.Parse()

	if err := codegen.Generate(*config, *domain, *resource, *outputDir); err != nil {
		fmt.Println(err)
		return
	}
}
