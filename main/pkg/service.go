package pkg

import (
	"log"

	"github.com/spf13/cobra"

	syspkg "github.com/getcouragenow/sys-share/sys-account/service/go/pkg"

	modpkg "github.com/getcouragenow/mod/mod-account/service/go/pkg"
)

// Invoke ...
func ProxyClient() *cobra.Command {
	// load up the sub grpc Services proxy

	log.Println(" -- mod proxy cli -- ")

	// load up
	log.Println(" -- Load Mod cli -- ")
	spsc1 := modpkg.NewSysShareProxyClient()
	rootCmd1 := spsc.CobraCommand()

	// load up
	log.Println(" -- Load Sys proxy cli -- ")
	spsc := syspkg.NewSysShareProxyClient()
	rootCmd := spsc.CobraCommand()

	return rootCmd

}
