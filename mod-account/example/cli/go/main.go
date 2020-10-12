package main

import (
	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"

	sysrpc "github.com/getcouragenow/sys-share/sys-account/service/go/rpc/v2"
	// modrpc "github.com/getcouragenow/mod/mod-account/service/go/rpc/v2"
)

var rootCmd = &cobra.Command{
	Use:   "auth",
	Short: "auth cli",
}

func main() {

	rootCmd.AddCommand(sysrpc.AuthServiceClientCommand())
	if err := rootCmd.Execute(); err != nil {
		log.Fatalf("command failed: %v", err)
	}

	/*
		modCmd.AddCommand(modrpc.AuthServiceClientCommand())
		if err := modCmd.Execute(); err != nil {
			log.Fatalf("command failed: %v", err)
		}
	*/

	// Extend it here for local thing.
	// TODO @gutterbacon: do this once Config is here.
}
