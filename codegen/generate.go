package codegen

import (
	_ "embed"
	"fmt"
	"log"
	"os"
	"path"
	"path/filepath"
	"strconv"
	"strings"

	"github.com/zclconf/go-cty/cty"
	"github.com/zclconf/go-cty/cty/gocty"

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

	if p.Params != nil {
		params := make([]string, len(p.Params))
		for i, v := range p.Params {
			switch v.Type() {
			case cty.String:
				var newVal string
				_ = gocty.FromCtyValue(v, &newVal)
				params[i] = strconv.Quote(newVal)
			case cty.Number:
				var newVal int
				_ = gocty.FromCtyValue(v, &newVal)
				params[i] = strconv.Itoa(newVal)
			case cty.NilType:
				params[i] = "nil"
			}
		}
		return fmt.Sprintf("%s(%s)", pkg+p.Type.Name(), strings.Join(params, ","))
	}
	return pkg + p.Type.Name()
}
