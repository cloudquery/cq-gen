
service = "test"
output_directory = "./tests/output"

resource "test" "base" "simple" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.BaseStruct"
}

resource "test" "base" "complex" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.ComplexStruct"
}