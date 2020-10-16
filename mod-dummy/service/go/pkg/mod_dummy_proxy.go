package pkg

/*

Used by higher up modules to reach mod-dummy ...

*/

import (
	"context"

	"github.com/spf13/cobra"
	"google.golang.org/grpc"

	rpc "github.com/getcouragenow/mod/mod-dummy/service/go/rpc/v2"
	sysSharePkg "github.com/getcouragenow/sys-share/sys-account/service/go/pkg"
)

// ModDummyClient is just a stub
type modDummyClient struct {
	sysShareAccountClient *cobra.Command
	dummyClient           *cobra.Command
}

func newModDummyClient() *modDummyClient {

	return &modDummyClient{
		sysShareAccountClient: sysSharePkg.NewSysShareProxyClient().CobraCommand(),
		dummyClient:           rpc.DummyServiceClientCommand(),
	}
}

func (mdc *modDummyClient) cobraCommand() *cobra.Command {
	rootCmd := &cobra.Command{
		Use:   "mod-dummy client",
		Short: "mod-dummy client cli",
	}
	rootCmd.AddCommand(mdc.dummyClient, mdc.sysShareAccountClient)
	return rootCmd
}

// ModDummyService contains the account and auth service as defined by
// the protobuf in the sys-share/sys-account/proto/v2
type modDummyService struct {
	dummy              *dummyService
	sysShareAccountSvc *sysSharePkg.SysAccountProxyService
}

// NewModDummyService creates new ModDummyService object
// it contains account and auth service as defined by the protobuf service definition
func newModDummyService(dr *ModDummyRepo) *modDummyService {
	dummySvc := newDummyService(dr)
	shareAccountSvc := sysSharePkg.NewSysAccountProxyService(dr.shareAccountSvc, dr.shareAuthSvc)
	return &modDummyService{
		dummy:              dummySvc,
		sysShareAccountSvc: shareAccountSvc,
	}
}

// RegisterSvc will register all the services contained within ModDummyService
// Essentially just
// DummyService itself
// and SysShareAccountService
func (mds *modDummyService) registerSvc(server *grpc.Server) {
	mds.dummy.registerSvc(server)
	//mds.sysShareAccountSvc.RegisterSvc(server)
}

// DummyService is the abstract contract needed to satisfy the
// DummyServiceService defined in the protobuf v2.
type DummyService interface {
	GetAccount(context.Context, *GetAccountRequest) (*Account, error)

}

func getAccountProxy(ds DummyService) func(context.Context, *rpc.GetAccountRequest) (*rpc.Account, error) {
	return func(ctx context.Context, acc *rpc.GetAccountRequest) (*rpc.Account, error) {
		account, err := ds.GetAccount(ctx, &GetAccountRequest{Id: acc.GetId()})
		if err != nil {
			return nil, err
		}
		return account.ToProto()
	}
}


type dummyService struct {
	svc *rpc.DummyServiceService
}

func newDummyService(ds DummyService) *dummyService {
	return &dummyService{
		svc: &rpc.DummyServiceService{
			GetAccount: getAccountProxy(ds),
		},
	}
}

func (ds *dummyService) registerSvc(server *grpc.Server) {
	rpc.RegisterDummyServiceService(server, ds.svc)
}
