package codegen

import (
	"fmt"
	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-gen/codegen/templates"
	"path"
)

func Generate(configPath string) error {

	cfg, err := config.Parse(configPath)
	if err != nil {
		return err
	}
	resources, err := buildResources(cfg)
	if err != nil {
		return err
	}

	for _, resource := range resources {
		err = templates.Render(templates.Options{
			Template:    "codegen/table.gotpl",
			Filename:    path.Join(cfg.OutputDirectory, fmt.Sprintf("%s_%s.go", resource.Config.Domain, resource.Config.Name)),
			PackageName: path.Base(cfg.OutputDirectory),
			Data:        resource,
			Funcs:       nil,
		})
		if err != nil {
			return err
		}
	}
	return nil
}
