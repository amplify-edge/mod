package service

import (
	"fmt"
	sharedConfig "github.com/getcouragenow/sys-share/sys-core/service/config"
	"gopkg.in/yaml.v2"
)

const (
	errParsingConfig           = "error parsing %s config: %v\n"
	errNoUnauthenticatedRoutes = "error: no unauthenticated routes defined"
)

type ModDiscoConfig struct {
	ModDiscoConfig Config `yaml:"modDiscoConfig" mapstructure:"modDiscoConfig"`
}

func (m *ModDiscoConfig) Validate() error {
	return m.ModDiscoConfig.validate()
}

type Config struct {
	UnauthenticatedRoutes []string `json:"unauthenticatedRoutes" yaml:"unauthenticatedRoutes"`
}

func (c Config) validate() error {
	if len(c.UnauthenticatedRoutes) == 0 {
		return fmt.Errorf(errNoUnauthenticatedRoutes)
	}
	return nil
}

func NewConfig(filepath string) (*ModDiscoConfig, error) {
	cfg := &ModDiscoConfig{}
	f, err := sharedConfig.LoadFile(filepath)
	if err != nil {
		return nil, err
	}
	if err := yaml.UnmarshalStrict(f, &cfg); err != nil {
		return nil, fmt.Errorf(errParsingConfig, filepath, err)
	}
	if err := cfg.Validate(); err != nil {
		return nil, err
	}
	return cfg, nil
}
