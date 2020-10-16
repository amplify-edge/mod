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

func (mdr *ModDummyRepo) GetAccount(ctx context.Context, in *GetAccountRequest) (*Account, error) {
	if in == nil {
		return nil, status.Error(codes.InvalidArgument, "cannot get account, invalid param")
	}
	req := in.ToSysShareProto()
	if mdr.shareClient != nil {
		return mdr.getv3(ctx, req)
	}
	return mdr.getv2(ctx, req)
}

func (mdr *ModDummyRepo) getv2(ctx context.Context, req *sysSharePkg.GetAccountRequest) (*Account, error) {
	resp, err := mdr.shareAccountSvc.GetAccount(ctx, req)
	if err != nil {
		return nil, err
	}
	return AccountFromSys(resp), nil
}

func (mdr *ModDummyRepo) getv3(ctx context.Context, req *sysSharePkg.GetAccountRequest) (*Account, error) {
	resp, err := mdr.shareClient.GetAccount(ctx, req)
	if err != nil {
		return nil, err
	}
	return AccountFromSys(resp), nil
}
