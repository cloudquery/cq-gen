package codegen

import (
	"fmt"
	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-gen/codegen/source/golang"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestTableBuilder_BuildTable(t *testing.T) {

	//source, _ := openapi.NewOpenAPIDataSource("C:\\Users\\Ron-Work\\Downloads\\DigitalOcean-public.v2.yaml")
	source := golang.NewDataSource()
	tb := NewTableBuilder(source)

	def, err := tb.BuildTable(nil, config.ResourceConfig{
		Service:                 "digitalocean",
		Domain:                  "",
		Name:                    "droplet",
		Path:                    "github.com/digitalocean/godo.Droplet",
	})
	assert.Nil(t, err)
	for _, c := range def.Columns {
		fmt.Println(c.Name)
	}

}