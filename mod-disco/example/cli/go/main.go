package main

import (
	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	"github.com/sirupsen/logrus"
)

func main() {
	l := logrus.New().WithField("mod-cli", "mod-disco")
	rootCmd := discoRpc.SurveyServiceClientCommand()
	if err := rootCmd.Execute(); err != nil {
		l.Fatalf("error running mod-cli mod-disco: %v", err)
	}
}
