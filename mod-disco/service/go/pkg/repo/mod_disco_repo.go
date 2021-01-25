package repo

import (
	"context"
	service "github.com/getcouragenow/mod/mod-disco/service/go"
	"github.com/getcouragenow/mod/mod-disco/service/go/pkg/dao"
	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	sharedAccountPkg "github.com/getcouragenow/sys-share/sys-account/service/go/pkg"
	"github.com/getcouragenow/sys-share/sys-account/service/go/pkg/interceptor"
	sharedConfig "github.com/getcouragenow/sys-share/sys-core/service/config"
	corebus "github.com/getcouragenow/sys-share/sys-core/service/go/pkg/bus"
	"github.com/getcouragenow/sys-share/sys-core/service/logging"
	"github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
	corefile "github.com/getcouragenow/sys/sys-core/service/go/pkg/filesvc/repo"
	"google.golang.org/protobuf/types/known/emptypb"
)

const (
	moduleName = "mod-disco"
)

type (
	ModDiscoRepo struct {
		store                 *dao.ModDiscoDB
		log                   logging.Logger
		serverInterceptor     func(context.Context) (context.Context, error)
		ClientInterceptor     *interceptor.ClientSide
		busClient             *corebus.CoreBus
		unauthenticatedRoutes []string
		busClientRoutes       []string
		accountClient         *sharedAccountPkg.SysAccountProxyServiceClient
		frepo                 *corefile.SysFileRepo
	}
)

func NewDiscoRepo(
	l logging.Logger, db *coredb.CoreDB,
	cfg *service.ModDiscoConfig,
	busClient *corebus.CoreBus,
	accountClient *sharedAccountPkg.SysAccountProxyServiceClient,
	frepo *corefile.SysFileRepo,
) (*ModDiscoRepo, error) {
	discodb, err := dao.NewModDiscoDB(db, l)
	if err != nil {
		l.Errorf("Error while initiating DAO: %v", err)
	}
	mdr := &ModDiscoRepo{
		store:                 discodb,
		log:                   l,
		unauthenticatedRoutes: cfg.ModDiscoConfig.UnauthenticatedRoutes,
		busClientRoutes:       cfg.ModDiscoConfig.BusClientRoutes,
		busClient:             busClient,
		accountClient:         accountClient,
		frepo:                 frepo,
	}
	busClient.RegisterAction("onDeleteDiscoProject", mdr.onDeleteDiscoProject)
	busClient.RegisterAction("onDeleteSurveyProject", mdr.onDeleteSurveyProject)
	busClient.RegisterAction("onDeleteSurveyUser", mdr.onDeleteSurveyUser)
	busClient.RegisterAction("onLoginCreateInterceptor", mdr.newClientInterceptor)
	busClient.RegisterAction("onLogoutRemoveInterceptor", mdr.removeClientInterceptor)
	busClient.RegisterAction("onResetAllModDisco", mdr.onResetAllModDisco)
	return mdr, nil
}

func (md *ModDiscoRepo) GenTempId(ctx context.Context, in *emptypb.Empty) (*discoRpc.GenIdResponse, error) {
	return &discoRpc.GenIdResponse{TempId: sharedConfig.NewID()}, nil
}
