package codegen

import (
	_ "embed"
	"fmt"
	"log"
	"path"

	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-gen/codegen/template"
)

//go:embed table.gotpl
var tableTemplate string

func Generate(configPath, domain, resourceName, outputDir string) error {
	cfg, diags := config.ParseConfiguration(configPath)
	if diags.HasErrors() {
		for _, d := range diags {
			log.Printf("configuration error: %s", d.Error())
		}
		return fmt.Errorf("failed to parse configuration")
	}
	resources, err := buildResources(cfg, domain, resourceName)
	if err != nil {
		return err
	}
	if outputDir == "" {
		outputDir = cfg.OutputDirectory
	}

	for _, resource := range resources {
		err = template.Render(template.Options{
			Template:    tableTemplate,
			Filename:    path.Join(outputDir, resource.Table.FileName),
			PackageName: path.Base(outputDir),
			Data:        resource,
			Funcs: map[string]interface{}{
				"call": Call,
			},
		})
		if err != nil {
			return err
		}
	}
	return nil
}

func Call(p *ResolverDefinition) string {
	if p == nil {
		return ""
	}
	if p.Type == nil {
		return p.Signature
	}
	pkgPath := p.Type.Pkg().Path()
	pkg := template.CurrentImports.Lookup(pkgPath)

	if pkg != "" {
		pkg += "."
	}
	if p.Signature != "" {
		return p.Signature
	}
	return pkg + p.Type.Name()
}
