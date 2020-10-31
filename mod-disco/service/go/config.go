package service

import (
	"fmt"
	sharedConfig "github.com/getcouragenow/sys-share/sys-core/service/config"
	commonCfg "github.com/getcouragenow/sys-share/sys-core/service/config/common"
	sysCoreConfig "github.com/getcouragenow/sys/sys-core/service/go"
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
	SysCoreConfig         sysCoreConfig.SysCoreConfig `yaml:"sysCoreConfig" mapstructure:"sysCoreConfig"`
	UnauthenticatedRoutes []string                    `json:"unauthenticatedRoutes" yaml:"unauthenticatedRoutes"`
	JWTConfig             JWTConfig                   `json:"jwt" yaml:"jwt"`
}

func (c Config) validate() error {
	if len(c.UnauthenticatedRoutes) == 0 {
		return fmt.Errorf(errNoUnauthenticatedRoutes)
	}
	if err := c.SysCoreConfig.Validate(); err != nil {
		return err
	}
	return c.JWTConfig.Validate()
}

type JWTConfig struct {
	Access  commonCfg.TokenConfig `json:"access" yaml:"access" mapstructure:"access"`
	Refresh commonCfg.TokenConfig `json:"refresh" yaml:"refresh" mapstructure:"refresh"`
}

func (j JWTConfig) Validate() error {
	if err := j.Access.Validate(); err != nil {
		return err
	}
	if err := j.Refresh.Validate(); err != nil {
		return err
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
