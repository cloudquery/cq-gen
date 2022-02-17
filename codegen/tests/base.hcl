service          = "test"
output_directory = "./tests/output/base/"

resource "test" "base" "simple" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.BaseStruct"
}

resource "test" "base" "complex" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.ComplexStruct"
}

resource "test" "base" "relations" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.RelationStruct"
}