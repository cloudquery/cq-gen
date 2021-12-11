
service = "test"
output_directory = "./tests/output"


resource "test" "resolvers" "resolvers" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.BaseStruct"
  ignoreError "TestIgnoreError" {
    path = "github.com/cloudquery/cq-gen/codegen/tests.IgnoreErrorFunc"
  }
  multiplex "TestMultiplex" {
    path = "github.com/cloudquery/cq-gen/codegen/tests.TestMultiplex"
  }
  deleteFilter "TestDeleteFilter" {
    path = "github.com/cloudquery/cq-gen/codegen/tests.TestDeleteFilter"
  }
  postResourceResolver "GeneratedPostResolver" {
    path     = "github.com/cloudquery/cq-provider-sdk/provider/schema.RowResolver"
    generate = true
  }
}