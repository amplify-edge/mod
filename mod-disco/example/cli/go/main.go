package main

import (
	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	"github.com/getcouragenow/sys-share/sys-core/service/logging/zaplog"
)

func main() {
	l := zaplog.NewZapLogger("debug", "mod-cli", true)
	l.InitLogger(nil)
	rootCmd := discoRpc.SurveyServiceClientCommand()
	if err := rootCmd.Execute(); err != nil {
		l.Fatalf("error running mod-cli mod-disco: %v", err)
	}
}
