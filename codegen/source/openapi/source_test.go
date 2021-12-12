package openapi

import (
	"fmt"
	"testing"
)

func TestOpenApiDataSource(t *testing.T) {

	source, err := NewOpenAPIDataSource("C:\\Users\\Ron-Work\\Downloads\\DigitalOcean-public.v2.yaml")
	fmt.Println(err)
	obj, _ := source.Find("droplet")
	for _, f := range obj.Fields() {
		//fmt.Println(f.Name())
		//fmt.Println(f.Description())
		fmt.Println(f.Type())
	}
}
