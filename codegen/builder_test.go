package codegen

//func TestTableBuilder_BuildTable(t *testing.T) {
//
//	//source, _ := openapi.NewOpenAPIDataSource("C:\\Users\\Ron-Work\\Downloads\\DigitalOcean-public.v2.yaml")
//	dsource, _ := openapi.NewDescriptionSource("C:\\Users\\Ron-Work\\Downloads\\DigitalOcean-public.v2.yaml")
//	source := golang.NewDataSource()
//	rw, err := rewrite.New("")
//	assert.Nil(t, err)
//	tb := NewTableBuilder(source, dsource, rw)
//
//	def, err := tb.BuildTable(nil, &config.ResourceConfig{
//		Service: "digitalocean",
//		Domain:  "",
//		Name:    "droplet",
//		Path:    "github.com/digitalocean/godo.Droplet",
//	}, BuildMeta{
//		Depth:      0,
//		ColumnPath: "",
//		FieldPath:  "",
//	})
//	assert.Nil(t, err)
//	for _, c := range def.Columns {
//		fmt.Println(c.Description)
//		fmt.Println(c.Name)
//	}
//
//}
