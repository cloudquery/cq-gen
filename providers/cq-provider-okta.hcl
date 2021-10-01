service = "okta"
output_directory = "../cq-provider-okta/resources"


resource "okta" "" "users" {
  path = "github.com/okta/okta-sdk-golang/v2/okta.User"

  column "embedded" {
    skip = true
  }
  column "links" {
    skip = true
  }

  column "type_links" {
    skip = true
  }
}