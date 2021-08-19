package codegen

import (
	"fmt"
	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-gen/codegen/template"
	"path"
)

func Generate(configPath string, domain string, resourceName string) error {
	cfg, err := config.Parse(configPath)
	if err != nil {
		return err
	}
	resources, err := buildResources(cfg, domain, resourceName)
	if err != nil {
		return err
	}

	for _, resource := range resources {
		fileName := fmt.Sprintf("%s_%s.go", resource.Config.Domain, resource.Config.Name)
		if resource.Config.Domain == "" {
			fileName = fmt.Sprintf("%s.go", resource.Config.Name)
		}
		err = template.Render(template.Options{
			Template:    "codegen/table.gotpl",
			Filename:    path.Join(cfg.OutputDirectory, fileName),
			PackageName: path.Base(cfg.OutputDirectory),
			Data:        resource,
			Funcs:       map[string]interface{}{
				"call": Call,
			},
		})
		if err != nil {
			return err
		}
	}
	return nil
}

func Call(p *FunctionDefinition) string {
	if p == nil {
		return ""
	}
	if p.Type == nil {
		return p.Signature
	}
	path := p.Type.Pkg().Path()
	pkg := template.CurrentImports.Lookup(path)

	if pkg != "" {
		pkg += "."
	}
	if p.Signature != "" {
		return p.Signature
	}
	return pkg + p.Type.Name()
}
