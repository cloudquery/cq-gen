package codegen

import (
	"fmt"
	"path"

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
		dsrc, err = openapi.NewDescriptionSource(cfg.DescriptionSource.Path)
		if err != nil {
			return nil, err
		}
	}

	tb := NewTableBuilder(src, dsrc, rw)
	resources := make([]*ResourceDefinition, 0)
	for _, resource := range cfg.Resources {
		if domain != "" && resource.Domain != domain {
			continue
		}
		if resourceName != "" && resource.Name != resourceName {
			continue
		}
		t, err := tb.BuildTable(nil, &resource, BuildMeta{})
		if err != nil {
			return nil, err
		}
		resources = append(resources, &ResourceDefinition{
			Config:          resource,
			Table:           t,
			RemainingSource: tb.rewriter.RemainingSource(path.Join(cfg.OutputDirectory, t.FileName)),
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
