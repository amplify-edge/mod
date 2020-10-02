package main

import (
	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"

	rpc "github.com/getcouragenow/sys-share/sys-account/server/rpc/v2"
)

var rootCmd = &cobra.Command{
	Use:   "auth",
	Short: "auth cli",
}

func main() {
	rootCmd.AddCommand(rpc.AuthServiceClientCommand())
	if err := rootCmd.Execute(); err != nil {
		log.Fatalf("command failed: %v", err)
	}

	// Extend it here for local thing.
	// TODO @gutterbacon: do this once Config is here.
}
