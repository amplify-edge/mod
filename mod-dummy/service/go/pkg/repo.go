package pkg

import (
	"context"
	"errors"
	sysSharePkg "github.com/getcouragenow/sys-share/sys-account/service/go/pkg"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type ModDummyRepo struct {
	shareClient     *sysSharePkg.SysAccountProxyServiceClient
	shareAccountSvc sysSharePkg.AccountService
	shareAuthSvc    sysSharePkg.AuthService
}

func NewModDummyRepo(grpcConn grpc.ClientConnInterface, accountSvc sysSharePkg.AccountService, authSvc sysSharePkg.AuthService) (*ModDummyRepo, error) {
	var shareClient *sysSharePkg.SysAccountProxyServiceClient
	if grpcConn == nil && accountSvc == nil && authSvc == nil {
		return nil, errors.New("invalid args, all params are nil")
	}
	if grpcConn != nil {
		shareClient = sysSharePkg.NewSysAccountProxyServiceClient(grpcConn)
	}
	return &ModDummyRepo{
		shareClient,
		accountSvc,
		authSvc,
	}, nil
}

func (mdr *ModDummyRepo) ListAccounts(ctx context.Context, in *ListAccountsRequest) (*ListAccountsResponse, error) {
	if in == nil {
		return nil, status.Error(codes.InvalidArgument, "cannot list accounts, invalid param")
	}
	req := in.ToSysShareProto()
	if mdr.shareClient != nil {
		return mdr.listv2(ctx, req)
	}
	return mdr.listv3(ctx, req)
}

func (mdr *ModDummyRepo) listv2(ctx context.Context, req *sysSharePkg.ListAccountsRequest) (*ListAccountsResponse, error) {
	resp, err := mdr.shareAccountSvc.ListAccounts(ctx, req)
	if err != nil {
		return nil, err
	}
	return ListAccountsResponseFromSys(resp), nil
}

func (mdr *ModDummyRepo) listv3(ctx context.Context, req *sysSharePkg.ListAccountsRequest) (*ListAccountsResponse, error) {
	resp, err := mdr.shareClient.ListAccounts(ctx, req)
	if err != nil {
		return nil, err
	}
	return ListAccountsResponseFromSys(resp), nil
}
