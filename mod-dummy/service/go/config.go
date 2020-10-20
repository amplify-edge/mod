package service

import (
	"fmt"
	"gopkg.in/yaml.v2"
	"os"

	sharedConfig "github.com/getcouragenow/sys-share/sys-core/service/config"
)

const (
	errParsingConfig = "error parsing %s config: %v"
	errDbNameEmpty   = "error: db name empty"
	errDbRotation    = "error: db rotation has to be greater than or equal to 1 (day)"
	errCronSchedule  = "error: db cron schedule is in wrong format / empty"
	defaultDirPerm   = 0755
)

type ModDummyConfig struct {
	ModDummyConfig Config `yaml:"modDummyConfig" mapstructure:"modDummyConfig"`
}

func NewConfig(filepath string) (*ModDummyConfig, error) {
	cfg := &ModDummyConfig{}
	f, err := sharedConfig.LoadFile(filepath)
	if err != nil {
		return nil, err
	}
	err = yaml.UnmarshalStrict(f, &cfg)
	if err != nil {
		return nil, err
	}
	if err := cfg.Validate(); err != nil {
		return nil, err
	}
	return cfg, nil
}

func (m *ModDummyConfig) Validate() error {
	return m.ModDummyConfig.validate()
}

type Config struct {
	UnauthenticatedRoutes []string   `json:"unauthenticatedRoutes" yaml:"unauthenticatedRoutes"`
	DbConfig              DbConfig   `json:"db" yaml:"db"`
	CronConfig            CronConfig `json:"cron" yaml:"cron"`
}

func (c Config) validate() error {
	if len(c.UnauthenticatedRoutes) == 0 {
		return fmt.Errorf(errParsingConfig, "mod-dummy-config", "unauthenticated routes are empty")
	}
	return c.DbConfig.validate()
}

type DbConfig struct {
	Name             string `json:"name" yaml:"name" mapstructure:"name"`
	EncryptKey       string `json:"encryptKey" yaml:"encryptKey" mapstructure:"encryptKey"`
	RotationDuration int    `json:"rotationDuration" yaml:"rotationDuration" mapstructure:"rotationDuration"`
	DbDir            string `json:"dbDir" yaml:"dbDir" mapstructure:"dbDir"`
}

func (d DbConfig) validate() error {
	if d.Name == "" {
		return fmt.Errorf(errDbNameEmpty)
	}
	if d.RotationDuration < 1 {
		return fmt.Errorf(errDbRotation)
	}
	if d.EncryptKey == "" {
		encKey, err := sharedConfig.GenRandomByteSlice(32)
		if err != nil {
			return err
		}
		d.EncryptKey = string(encKey)
	}
	exists, err := sharedConfig.PathExists(d.DbDir)
	if err != nil || !exists {
		return os.MkdirAll(d.DbDir, defaultDirPerm)
	}
	return nil
}

type CronConfig struct {
	BackupSchedule string `json:"backupSchedule" yaml:"backupSchedule" mapstructure:"backupSchedule"`
	RotateSchedule string `json:"rotateSchedule" yaml:"rotateSchedule" mapstructure:"rotateSchedule"`
	BackupDir      string `json:"backupDir" yaml:"backupDir" mapstructure:"backupDir"`
}

func (c CronConfig) validate() error {
	if c.BackupSchedule == "" || c.RotateSchedule == "" {
		return fmt.Errorf(errCronSchedule)
	}
	if exists, err := sharedConfig.PathExists(c.BackupDir); err != nil || !exists {
		return os.MkdirAll(c.BackupDir, defaultDirPerm)
	}
	return nil
}
