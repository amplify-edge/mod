package main

import (
	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"

	dummyPkg "github.com/getcouragenow/mod/mod-dummy/service/go/pkg"
)

var rootCmd = &cobra.Command{
	Use:   "dummy",
	Short: "dummy cli",
}

func main() {

	dummyProxyClient := dummyPkg.NewModDummyProxyClient()
	rootCmd.AddCommand(dummyProxyClient.CobraCommand())

	if err := rootCmd.Execute(); err != nil {
		log.Fatalf("command failed: %v", err)
	}

	// Extend it here for local thing.
	// TODO @gutterbacon: do this once Config is here.
}
