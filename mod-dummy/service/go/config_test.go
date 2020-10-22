package service_test

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"

	dummycfg "github.com/getcouragenow/mod/mod-dummy/service/go"
)

func TestNewSysCoreConfig(t *testing.T) {
	baseTestDir := "./test/config"
	// Test nonexistent config
	_, err := dummycfg.NewConfig("./nonexistent.yml")
	assert.Error(t, err)
	// Test valid config
	sysCoreCfg, err := dummycfg.NewConfig(fmt.Sprintf("%s/%s", baseTestDir, "valid.yml"))
	assert.NoError(t, err)
	expected := &dummycfg.ModDummyConfig{
		ModDummyConfig: dummycfg.Config{
			UnauthenticatedRoutes: []string{
				"/v2.mod.services.ModDummy/GetAccount",
			},
			DbConfig: dummycfg.DbConfig{
				Name:             "getcouragenow.db",
				EncryptKey:       "testkey!@",
				RotationDuration: 1,
				DbDir:            "./db",
			},
			CronConfig: dummycfg.CronConfig{
				BackupSchedule: "@daily",
				RotateSchedule: "@every 24h",
				BackupDir:      "./db/backups",
			},
		},
	}
	assert.Equal(t, expected, sysCoreCfg)
}
