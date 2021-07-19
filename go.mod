module github.com/cloudquery/cq-gen

go 1.15

require (
	//github.com/cloudquery/cq-provider-aws v0.4.11
	github.com/cloudquery/cq-provider-azure v0.2.2
	//github.com/cloudquery/cq-provider-digitalocean v0.0.0
	//github.com/cloudquery/cq-provider-gcp v0.3.2
	github.com/cloudquery/cq-provider-sdk v0.3.0-rc8
	//github.com/cloudquery/cq-provider-template v0.0.0-20210627091554-9dd674d0725c // indirect
	github.com/creasty/defaults v1.5.1
	github.com/fatih/color v1.12.0 // indirect
	github.com/google/go-cmp v0.5.6 // indirect
	github.com/hashicorp/go-hclog v0.16.1
	github.com/hashicorp/hcl/v2 v2.10.0
	github.com/iancoleman/strcase v0.1.3
	github.com/jinzhu/inflection v1.0.0
	github.com/modern-go/reflect2 v1.0.1
	github.com/pkg/errors v0.9.1
	golang.org/x/crypto v0.0.0-20210513164829-c07d793c2f9a // indirect
	golang.org/x/tools v0.1.3
)

// Note: add replace for your local provider so cq-gen rewriter will work properlly
replace (
	github.com/cloudquery/cq-provider-azure => ../cq-provider-azure
	//github.com/cloudquery/cq-provider-aws  => ../forks/cq-provider-aws
	//github.com/cloudquery/cq-provider-gcp  => ../cq-provider-gcp
	//github.com/cloudquery/cq-provider-digitalocean => ../cq-provider-digitalocean
)