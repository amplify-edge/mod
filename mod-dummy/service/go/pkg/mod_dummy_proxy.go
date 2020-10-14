package pkg

/*

Used by higher up modules to reach mod-dummy ...

*/

import (
	"context"

	"github.com/spf13/cobra"
	"google.golang.org/grpc"

	rpc "github.com/getcouragenow/mod/mod-dummy/service/go/rpc/v2"
)

// SysAccountClient is just a stub
type sysAccountClient struct {
	auth    *cobra.Command
	account *cobra.Command
}

func newSysAccountClient() *sysAccountClient {

	return &sysAccountClient{
		account: rpc.AccountServiceClientCommand(),
	}
}

func (sac *sysAccountClient) cobraCommand() *cobra.Command {
	rootCmd := &cobra.Command{
		Use:   "sys-account client",
		Short: "sys-account client cli",
	}
	rootCmd.AddCommand(sac.auth, sac.account)
	return rootCmd
}

// SysAccountService contains the account and auth service as defined by
// the protobuf in the sys-share/sys-account/proto/v2
type sysAccountService struct {
	account *accountService
}

// NewSysAccountService creates new SysAccountService object
// it contains account and auth service as defined by the protobuf service definition
func newSysAccountService(acc AccountService) *sysAccountService {
	accountSvc := newAccountService(acc)
	return &sysAccountService{
		account: accountSvc,
	}
}

// RegisterSvc will register all the services contained within SysAccountService
func (sas *sysAccountService) registerSvc(server *grpc.Server) {
	sas.account.registerSvc(server)
}

// AccountService is the abstract contract needed to satisfy the
// AccountServiceService defined in the protobuf v2.
type AccountService interface {
	ListAccounts(context.Context, *ListAccountsRequest) (*ListAccountsResponse, error)
}

func listAccountsProxy(as AccountService) func(context.Context, *rpc.ListAccountsRequest) (*rpc.ListAccountsResponse, error) {
	return func(ctx context.Context, lar *rpc.ListAccountsRequest) (*rpc.ListAccountsResponse, error) {
		accounts, err := as.ListAccounts(ctx, ListAccountsRequestFromProto(lar))
		if err != nil {
			return nil, err
		}
		return accounts.ToProto()
	}
}

// Thin wrapper around rpc defined services
type accountService struct {
	svc *rpc.AccountServiceService
}

func newAccountService(acc AccountService) *accountService {
	return &accountService{
		svc: &rpc.AccountServiceService{

			ListAccounts: listAccountsProxy(acc),
		},
	}
}

func (a *accountService) registerSvc(server *grpc.Server) {
	rpc.RegisterAccountServiceService(server, a.svc)
}
