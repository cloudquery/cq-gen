package codegen

import (
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
