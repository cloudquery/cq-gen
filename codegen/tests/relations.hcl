service          = "test"
output_directory = "./tests/output"

resource "test" "base" "relations" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.RelationStruct"
}