package repo

import (
	"context"
	service "github.com/getcouragenow/mod/mod-disco/service/go"
	"github.com/getcouragenow/mod/mod-disco/service/go/pkg/dao"
	"github.com/getcouragenow/sys-share/sys-account/service/go/pkg/interceptor"
	"github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
	l "github.com/sirupsen/logrus"
)

type (
	ModDiscoRepo struct {
		store                 *dao.ModDiscoDB
		log                   *l.Entry
		serverInterceptor     func(context.Context) (context.Context, error)
		clientInterceptor     *interceptor.ClientSide
		unauthenticatedRoutes []string
	}
)

func NewDiscoRepo(
	l *l.Entry, db *coredb.CoreDB,
	cfg *service.ModDiscoConfig,
	serverInterceptor func(context.Context) (context.Context, error),
	clientInterceptor *interceptor.ClientSide,
) (*ModDiscoRepo, error) {
	discodb, err := dao.NewModDiscoDB(db, l)
	if err != nil {
		l.Errorf("Error while initiating DAO: %v", err)
	}
	return &ModDiscoRepo{
		store:                 discodb,
		log:                   l,
		serverInterceptor:     serverInterceptor,
		clientInterceptor:     clientInterceptor,
		unauthenticatedRoutes: cfg.ModDiscoConfig.UnauthenticatedRoutes,
	}, nil
}
