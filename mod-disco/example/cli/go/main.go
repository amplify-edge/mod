package main

import (
	discoRpc "github.com/amplify-cms/mod/mod-disco/service/go/rpc/v2"
	"github.com/amplify-cms/sys-share/sys-core/service/logging/zaplog"
)

func main() {
	l := zaplog.NewZapLogger(zaplog.DEBUG, "mod-cli", true, "")
	l.InitLogger(nil)
	rootCmd := discoRpc.SurveyServiceClientCommand()
	if err := rootCmd.Execute(); err != nil {
		l.Fatalf("error running mod-cli mod-disco: %v", err)
	}
}
