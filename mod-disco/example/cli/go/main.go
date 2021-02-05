package main

import (
	discoRpc "go.amplifyedge.org/mod-v2/mod-disco/service/go/rpc/v2"
	"go.amplifyedge.org/sys-share-v2/sys-core/service/logging/zaplog"
)

func main() {
	l := zaplog.NewZapLogger(zaplog.DEBUG, "mod-cli", true, "")
	l.InitLogger(nil)
	rootCmd := discoRpc.SurveyServiceClientCommand()
	if err := rootCmd.Execute(); err != nil {
		l.Fatalf("error running mod-cli mod-disco: %v", err)
	}
}
