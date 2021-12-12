package main

import (
	"flag"
	"fmt"

	"github.com/cloudquery/cq-gen/codegen"
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
