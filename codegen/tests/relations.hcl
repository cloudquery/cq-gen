service          = "test"
output_directory = "./tests/output/relations/"

resource "test" "relations" "rename" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.SimpleRelation"
  disable_pluralize = true

  relation "test" "base" "relations" {
    path = "github.com/cloudquery/cq-gen/codegen/tests.BaseStruct"
    rename = "renamed"
    disable_pluralize = true
  }
}


resource "test" "relations" "user_relation" {
  path = "github.com/cloudquery/cq-gen/codegen/tests.SimpleRelation"

  user_relation "test" "base" "user" {
    path = "github.com/cloudquery/cq-gen/codegen/tests.OtherStruct"
    disable_pluralize = true
  }

  user_relation "test" "base" "custom" {
    userDefinedColumn "test_column" {
      type              = "json"
      description       = "user defined column test"
      generate_resolver = true
    }
  }
}