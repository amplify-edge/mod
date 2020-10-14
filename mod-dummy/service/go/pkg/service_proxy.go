package pkg

/*

Used by mod-dummy to call into lower modules ...

when v2
- call sys-* over go.

when v3
- call sys-* over grpc.

*/

import (
	"context"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
	"golang.org/x/oauth2"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/oauth"
	"google.golang.org/grpc/reflection"

	cliClient "github.com/getcouragenow/protoc-gen-cobra/client"
	"github.com/getcouragenow/protoc-gen-cobra/naming"

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
	cliClient.RegisterFlagBinder(func(fs *pflag.FlagSet, namer naming.Namer) {
		fs.StringVar(&ModDummyProxyClientConfig.AccessKey, namer("JWT Access Token"), ModDummyProxyClientConfig.AccessKey, "JWT Access Token")
	})
	cliClient.RegisterPreDialer(func(_ context.Context, opts *[]grpc.DialOption) error {
		cfg := ModDummyProxyClientConfig
		if cfg.AccessKey != "" {
			cred := oauth.NewOauthAccess(&oauth2.Token{
				AccessToken: cfg.AccessKey,
				TokenType:   "Bearer",
			})
			*opts = append(*opts, grpc.WithPerRPCCredentials(cred))
		}
		return nil
	})
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
