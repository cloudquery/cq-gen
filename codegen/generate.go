package codegen

import (
	_ "embed"
	"fmt"
	"log"
	"os"
	"path"
	"path/filepath"

	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-gen/codegen/template"
)

//go:embed table.gotpl
var tableTemplate string

func Generate(configPath, domain, resourceName, outputDir string) error {
	wd, _ := os.Getwd()
	log.Printf("parsing configuration file %s, working directory: %s", configPath, wd)
	cfg, diags := config.ParseConfiguration(configPath)
	if diags.HasErrors() {
		for _, d := range diags {
			log.Printf("configuration error: %s", d.Error())
		}
		return fmt.Errorf("failed to parse configuration")
	}
	resources, err := buildResources(cfg, domain, resourceName)
	if err != nil {
		return fmt.Errorf("failed to build resources: %w", err)
	}
	if outputDir == "" {
		outputDir = cfg.OutputDirectory
	}
	absPath, err := filepath.Abs(outputDir)
	if err != nil {
		return fmt.Errorf("failed to get abs path of %s: %w", outputDir, err)
	}

	for _, resource := range resources {
		err = template.Render(template.Options{
			Template:    tableTemplate,
			Filename:    path.Join(outputDir, resource.Table.FileName),
			PackageName: filepath.Base(absPath),
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
