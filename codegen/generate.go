package codegen

import (
	"fmt"
	"github.com/cloudquery/cq-gen/codegen/config"
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
		err = Render(Options{
			Template:    "codegen/table.gotpl",
			Filename:    path.Join(cfg.OutputDirectory, fileName),
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
