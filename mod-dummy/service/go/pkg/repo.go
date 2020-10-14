package pkg

import (
	"context"
	sysSharePkg "github.com/getcouragenow/sys-share/sys-account/service/go/pkg"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type ModDummyRepo struct{
	grpcConn grpc.ClientConnInterface
}

func NewModDummyRepo(grpcConn grpc.ClientConnInterface) *ModDummyRepo {
	return &ModDummyRepo{
		grpcConn,
	}
}

func (mdr *ModDummyRepo) ListAccounts(_ context.Context, in *ListAccountsRequest) (*ListAccountsResponse, error) {
	if in == nil {
		return nil, status.Error(codes.InvalidArgument, "cannot list accounts, invalid param")
	}
	req := &sysSharePkg.ListAccountsRequest{
		PerPageEntries: in.PerPageEntries,
		OrderBy:        in.OrderBy,
		CurrentPageId:  in.CurrentPageId,
	}
}
