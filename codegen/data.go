package codegen

import (
	"fmt"
	"log"
	"path"

	"github.com/cloudquery/cq-gen/codegen/source/graphql"

	"github.com/cloudquery/cq-gen/codegen/config"
	"github.com/cloudquery/cq-gen/codegen/source"
	"github.com/cloudquery/cq-gen/codegen/source/golang"
	"github.com/cloudquery/cq-gen/codegen/source/openapi"
	"github.com/cloudquery/cq-gen/rewrite"
)

type ResourceDefinition struct {
	Config          config.ResourceConfig
	Table           *TableDefinition
	RemainingSource string
	GenerateHeader  string
}

func buildResources(cfg *config.Config, domain string, resourceName string) ([]*ResourceDefinition, error) {
	rw, err := rewrite.New(cfg.OutputDirectory)
	if err != nil {
		return nil, err
	}

	// checks for duplicates, although we duplicate this loop, it is more efficient to do this check before building
	// resources and then finding duplicates after build
	// TODO: move configuration checking into config package, requires more complex hcl checks
	if err := checkDuplicates(cfg.Resources, domain, resourceName); err != nil {
		return nil, err
	}

	var src source.DataSource
	if cfg.DataSource != nil {
		switch cfg.DataSource.Type {
		case "openapi":
			src, err = openapi.NewOpenAPIDataSource(cfg.DataSource.Path)
			if err != nil {
				return nil, err
			}
		case "golang":
			fallthrough
		default:
			src = golang.NewDataSource()
		}
	} else {
		src = golang.NewDataSource()
	}

	var dsrc source.DescriptionSource
	if cfg.DescriptionSource != nil {

		switch cfg.DescriptionSource.Type {
		case "openapi":
			dsrc, err = openapi.NewDescriptionSource(cfg.DescriptionSource.Path)
			if err != nil {
				return nil, err
			}
		case "graphql":
			dsrc, err = graphql.NewDescriptionSource(cfg.DescriptionSource.Path)
			if err != nil {
				return nil, err
			}
		}
	}

	parsers := make([]source.DescriptionParser, len(cfg.DescriptionModifiers))
	for i, p := range cfg.DescriptionModifiers {
		parsers[i] = source.NewUserDescriptionParser(p.Regex, p.RemoveWords)
	}

	tb := NewTableBuilder(src, dsrc, rw, parsers)
	resources := make([]*ResourceDefinition, 0)
	for _, resource := range cfg.Resources {
		if domain != "" && resource.Domain != domain {
			continue
		}
		if resourceName != "" && resource.Name != resourceName {
			continue
		}
		log.Printf("building table for resource %s", resource.Name)
		t, err := tb.BuildTable(nil, &resource, BuildMeta{})
		if err != nil {
			return nil, err
		}
		generateHeader := ""
		if cfg.AddGenerate {
			generateHeader = fmt.Sprintf("//go:generate cq-gen --resource %s --config %s --output .", resourceName, cfg.Path)
		}

		resources = append(resources, &ResourceDefinition{
			Config:          resource,
			Table:           t,
			RemainingSource: tb.rewriter.RemainingSource(path.Join(cfg.OutputDirectory, t.FileName)),
			GenerateHeader:  generateHeader,
		})
	}
	return resources, nil
}

func checkDuplicates(resources []config.ResourceConfig, domain, resourceName string) error {
	foundResources := make(map[string]bool)
	for _, resource := range resources {
		if domain != "" && resource.Domain != domain {
			continue
		}
		if resourceName != "" && resource.Name != resourceName {
			continue
		}
		rName := fmt.Sprintf("%s-%s", resource.Domain, resource.Name)
		if _, ok := foundResources[rName]; ok {
			return fmt.Errorf("duplicate resource found. Domain: %s Resource: %s", resource.Domain, resource.Name)
		}
		foundResources[rName] = true
	}
	return nil
}
