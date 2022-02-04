module github.com/cloudquery/cq-gen

go 1.16

require (
	github.com/cloudquery/cq-provider-azure v0.4.0 // indirect
	github.com/cloudquery/cq-provider-sdk v0.7.0
	github.com/creasty/defaults v1.5.2
	github.com/getkin/kin-openapi v0.83.0
	github.com/golang/groupcache v0.0.0-20210331224755-41bb18bfe9da // indirect
	github.com/hashicorp/go-hclog v1.0.0
	github.com/hashicorp/hcl/v2 v2.10.1
	github.com/hashicorp/terraform-exec v0.15.0 // indirect
	github.com/huandu/go-sqlbuilder v1.13.0 // indirect
	github.com/iancoleman/strcase v0.2.0
	github.com/jinzhu/inflection v1.0.0
	github.com/klauspost/compress v1.13.6 // indirect
	github.com/modern-go/reflect2 v1.0.2
	github.com/pkg/errors v0.9.1
	github.com/spf13/afero v1.6.0
	github.com/stretchr/testify v1.7.0
	github.com/tmccombs/hcl2json v0.3.3 // indirect
	github.com/vektah/gqlparser/v2 v2.2.0
	golang.org/x/tools v0.1.5
)

replace (
		github.com/cloudquery/cq-provider-azure => ../cq-provider-azure
)
