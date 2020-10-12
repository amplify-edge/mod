package pkg

import (
	"log"

	"github.com/spf13/cobra"

	modpkg "github.com/getcouragenow/mod/mod-account/service/go/pkg"
	syspkg "github.com/getcouragenow/sys-share/sys-account/service/go/pkg"
)

var rootCmd = &cobra.Command{
	Use: "mod-main",
}

// Invoke ...
func ProxyClient() *cobra.Command {
	// load up the sub grpc Services proxy

	log.Println(" -- mod proxy cli -- ")

	// load up mod-cli client
	log.Println(" -- Load Mod cli -- ")
	spsc1 := modpkg.NewSysShareProxyClient()

	// load up sys-cli client
	log.Println(" -- Load Sys proxy cli -- ")
	spsc := syspkg.NewSysShareProxyClient()

	// Add it to root cobra
	rootCmd.AddCommand(spsc1.CobraCommand(), spsc.CobraCommand())

	return rootCmd

}
