module github.com/cloudquery/cq-gen

go 1.15

require (
	github.com/cloudquery/cq-provider-azure v0.2.2
	github.com/cloudquery/cq-provider-digitalocean v0.2.0 // indirect
	github.com/cloudquery/cq-provider-sdk v0.4.8
	github.com/creasty/defaults v1.5.1
	github.com/fatih/color v1.12.0 // indirect
	github.com/getkin/kin-openapi v0.68.0
	github.com/google/go-cmp v0.5.6 // indirect
	github.com/hashicorp/go-hclog v0.16.2
	github.com/hashicorp/hcl/v2 v2.10.0
	github.com/iancoleman/strcase v0.1.3
	github.com/jinzhu/inflection v1.0.0
	github.com/jmespath/go-jmespath v0.4.0 // indirect
	github.com/julienschmidt/httprouter v1.3.0 // indirect
	github.com/modern-go/reflect2 v1.0.1
	github.com/pkg/errors v0.9.1
	github.com/stretchr/testify v1.7.0
	golang.org/x/tools v0.1.3
	google.golang.org/api v0.44.0 // indirect
	google.golang.org/genproto v0.0.0-20210510173355-fb37daa5cd7a // indirect
)

// Note: add replace for your local provider so cq-gen rewriter will work properlly
replace  (
	github.com/cloudquery/cq-provider-azure => ../cq-provider-azure
	//github.com/cloudquery/cq-provider-gcp => ../cq-provider-gcp
	//github.com/cloudquery/cq-provider-aws => ../cq-provider-aws
)