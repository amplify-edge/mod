package pkg

import (
	"log"

	"github.com/spf13/cobra"

	modpkg "github.com/getcouragenow/mod/mod-dummy/service/go/pkg"
	syspkg "github.com/getcouragenow/sys-share/sys-account/service/go/pkg"
)

var rootCmd = &cobra.Command{
	Use: "mod-main",
}

// Invoke ...
func ModProxyCli() *cobra.Command {
	// load up the sub grpc Services proxy

	log.Println(" -- mod proxy cli -- ")

	// load up mod-cli client
	log.Println(" -- Load Mod cli -- ")
	dummyCliClient := modpkg.NewModDummyProxyClient()

	// load up sys-cli client
	log.Println(" -- Load Sys proxy cli -- ")
	spsc := syspkg.NewSysShareProxyClient()

	// Add it to root cobra
	rootCmd.AddCommand(dummyCliClient.CobraCommand(), spsc.CobraCommand())

	return rootCmd
}

type ModProxyService struct {

}

