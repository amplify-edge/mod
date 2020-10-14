package pkg

import (
	"context"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type ModDummyRepo struct{}

func NewModDummyRepo() *ModDummyRepo {
	return &ModDummyRepo{}
}

func (mdr *ModDummyRepo) ListAccounts(_ context.Context, in *ListAccountsRequest) (*ListAccountsResponse, error) {
	if in == nil {
		return nil, status.Error(codes.InvalidArgument, "cannot list accounts, invalid param")
	}
	return &ListAccountsResponse{
		Accounts:   nil,
		NextPageId: "empty",
	}, nil
}
