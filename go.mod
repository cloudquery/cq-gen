module github.com/cloudquery/cq-gen

go 1.15

require (
	github.com/cloudquery/cq-provider-azure v0.2.2
	github.com/cloudquery/cq-provider-digitalocean v0.2.0
	github.com/cloudquery/cq-provider-sdk v0.4.9
	github.com/creasty/defaults v1.5.2
	github.com/getkin/kin-openapi v0.68.0
	github.com/google/go-cmp v0.5.6 // indirect
	github.com/hashicorp/go-hclog v1.0.0
	github.com/hashicorp/hcl/v2 v2.10.1
	github.com/iancoleman/strcase v0.2.0
	github.com/jinzhu/inflection v1.0.0
	github.com/jmespath/go-jmespath v0.4.0 // indirect
	github.com/julienschmidt/httprouter v1.3.0 // indirect
	github.com/modern-go/reflect2 v1.0.2
	github.com/pkg/errors v0.9.1
	github.com/stretchr/testify v1.7.0
	golang.org/x/tools v0.1.5
)

// Note: add replace for your local provider so cq-gen rewriter will work properlly
replace github.com/cloudquery/cq-provider-azure => ../cq-provider-azure
