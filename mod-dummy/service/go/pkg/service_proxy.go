package pkg

/*

Used by mod-dummy to call into lower modules ...

when v2
- call sys-* over go.

when v3
- call sys-* over grpc.

*/

import (
	"github.com/spf13/cobra"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	sysSharePkg "github.com/getcouragenow/sys-share/sys-account/service/go/pkg"
)

type ModDummyProxyService struct {
	modDummySvc *modDummyService
}

// Constructor for ModDummyProxyService
func NewModDummyProxyService(ds DummyService, accountSvc sysSharePkg.AccountService, authSvc sysSharePkg.AuthService) *ModDummyProxyService {
	modDummyProxy := newModDummyService(ds, accountSvc, authSvc)
	return &ModDummyProxyService{modDummySvc: modDummyProxy}
}

// ModDummyProxyService Register services to GRPC
func (s *ModDummyProxyService) RegisterSvc(server *grpc.Server) {
	s.modDummySvc.registerSvc(server)
	reflection.Register(server)
}

type ModDummyProxyClient struct {
	// This is correct naming..
	ModDummyClient *modDummyClient
}

func NewModDummyProxyClient() *ModDummyProxyClient {
	modDummyProxyClient := newModDummyClient()
	return &ModDummyProxyClient{
		ModDummyClient: modDummyProxyClient,
	}
}

type modDummyProxyClientConfig struct {
	AccessKey string
}

var ModDummyProxyClientConfig = &modDummyProxyClientConfig{}

// Easy access to create CLI
func (s *ModDummyProxyClient) CobraCommand() *cobra.Command {

	rootCmd := &cobra.Command{
		Use:   "mod-dummy proxy client",
		Short: "mod-dummy proxy client cli",
	}
	rootCmd.AddCommand(s.ModDummyClient.cobraCommand())
	return rootCmd
}
