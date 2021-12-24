service          = "test"
output_directory = "./tests/output"

resource "test" "bad" "duplicate" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.BaseStruct"
}

resource "test" "bad" "duplicate" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.BaseStruct"
}
