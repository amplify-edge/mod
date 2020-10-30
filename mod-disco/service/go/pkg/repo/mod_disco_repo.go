package repo

import (
	"context"
	service "github.com/getcouragenow/mod/mod-disco/service/go"
	"github.com/getcouragenow/mod/mod-disco/service/go/pkg/dao"
	sharedAccountPkg "github.com/getcouragenow/sys-share/sys-account/service/go/pkg"
	"github.com/getcouragenow/sys-share/sys-account/service/go/pkg/interceptor"
	corebus "github.com/getcouragenow/sys-share/sys-core/service/go/pkg/bus"
	"github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
	l "github.com/sirupsen/logrus"
)

type (
	ModDiscoRepo struct {
		store                 *dao.ModDiscoDB
		log                   *l.Entry
		serverInterceptor     func(context.Context) (context.Context, error)
		clientInterceptor     *interceptor.ClientSide
		busClient             *corebus.CoreBus
		unauthenticatedRoutes []string
		accountClient         *sharedAccountPkg.SysAccountProxyServiceClient
	}
)

func NewDiscoRepo(
	l *l.Entry, db *coredb.CoreDB,
	cfg *service.ModDiscoConfig,
	busClient *corebus.CoreBus,
	accountClient *sharedAccountPkg.SysAccountProxyServiceClient,
) (*ModDiscoRepo, error) {
	discodb, err := dao.NewModDiscoDB(db, l)
	if err != nil {
		l.Errorf("Error while initiating DAO: %v", err)
	}
	mdr := &ModDiscoRepo{
		store:                 discodb,
		log:                   l,
		unauthenticatedRoutes: cfg.ModDiscoConfig.UnauthenticatedRoutes,
		busClient:             busClient,
		accountClient:         accountClient,
	}
	busClient.RegisterAction("onDeleteDiscoProject", mdr.onDeleteDiscoProject)
	busClient.RegisterAction("onDeleteSurveyProject", mdr.onDeleteSurveyProject)
	busClient.RegisterAction("onDeleteSurveyUser", mdr.onDeleteSurveyUser)
	busClient.RegisterAction("onLoginCreateInterceptor", mdr.newClientInterceptor)
	busClient.RegisterAction("onLogoutRemoveInterceptor", mdr.removeClientInterceptor)
	return mdr, nil
}
