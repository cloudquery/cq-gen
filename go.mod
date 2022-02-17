module github.com/cloudquery/cq-gen

go 1.16

require (
	github.com/Azure/azure-sdk-for-go v61.5.0+incompatible // indirect
	github.com/Azure/go-autorest/autorest/azure/auth v0.5.11 // indirect
	github.com/Masterminds/squirrel v1.5.2 // indirect
	github.com/cloudquery/cq-provider-azure v0.6.0 // indirect
	github.com/cloudquery/cq-provider-sdk v0.8.2
	github.com/cloudquery/faker/v3 v3.7.5 // indirect
	github.com/creasty/defaults v1.5.2
	github.com/doug-martin/goqu/v9 v9.18.0 // indirect
	github.com/georgysavva/scany v0.3.0 // indirect
	github.com/getkin/kin-openapi v0.83.0
	github.com/gofrs/uuid v4.2.0+incompatible // indirect
	github.com/golang-jwt/jwt/v4 v4.3.0 // indirect
	github.com/golang-migrate/migrate/v4 v4.15.1 // indirect
	github.com/google/go-cmp v0.5.7 // indirect
	github.com/hashicorp/go-hclog v1.1.0
	github.com/hashicorp/go-version v1.4.0 // indirect
	github.com/hashicorp/hcl/v2 v2.11.1
	github.com/hashicorp/yamux v0.0.0-20211028200310-0bc27b27de87 // indirect
	github.com/iancoleman/strcase v0.2.0
	github.com/jackc/pgx/v4 v4.15.0 // indirect
	github.com/jinzhu/inflection v1.0.0
	github.com/kr/text v0.2.0 // indirect
	github.com/kylelemons/godebug v1.1.0 // indirect
	github.com/lib/pq v1.10.4 // indirect
	github.com/mattn/go-colorable v0.1.12 // indirect
	github.com/modern-go/reflect2 v1.0.2
	github.com/pkg/errors v0.9.1
	github.com/sergi/go-diff v1.2.0 // indirect
	github.com/spf13/afero v1.8.1
	github.com/stretchr/testify v1.7.0
	github.com/tombuildsstuff/giovanni v0.18.0 // indirect
	github.com/vektah/gqlparser/v2 v2.2.0
	github.com/vmihailenco/msgpack/v5 v5.3.5 // indirect
	github.com/xo/dburl v0.9.0 // indirect
	github.com/zclconf/go-cty v1.10.0 // indirect
	go.uber.org/atomic v1.9.0 // indirect
	golang.org/x/crypto v0.0.0-20220214200702-86341886e292 // indirect
	golang.org/x/net v0.0.0-20220127200216-cd36cc0744dd // indirect
	golang.org/x/sys v0.0.0-20220209214540-3681064d5158 // indirect
	golang.org/x/tools v0.1.5
	google.golang.org/genproto v0.0.0-20220216160803-4663080d8bc8 // indirect
	gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c // indirect
)

replace (
	github.com/cloudquery/cq-provider-azure => ../cq-provider-azure
)
