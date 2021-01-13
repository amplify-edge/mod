package pkg

import (
	"fmt"
	"github.com/sirupsen/logrus"
	"google.golang.org/grpc"

	"github.com/getcouragenow/mod/mod-disco/service/go/pkg/telemetry"
	corefile "github.com/getcouragenow/sys/sys-core/service/go/pkg/filesvc/repo"

	service "github.com/getcouragenow/mod/mod-disco/service/go"
	"github.com/getcouragenow/mod/mod-disco/service/go/pkg/repo"
	discoRpc "github.com/getcouragenow/mod/mod-disco/service/go/rpc/v2"
	sharedAccountPkg "github.com/getcouragenow/sys-share/sys-account/service/go/pkg"
	"github.com/getcouragenow/sys-share/sys-account/service/go/pkg/interceptor"
	sharedBus "github.com/getcouragenow/sys-share/sys-core/service/go/pkg/bus"
	"github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
)

type ModDiscoService struct {
	proxyService      *discoRpc.SurveyServiceService
	ClientInterceptor *interceptor.ClientSide
	ModDiscoRepo      *repo.ModDiscoRepo
	BusinessTelemetry *telemetry.ModDiscoMetrics
}

type ModDiscoServiceConfig struct {
	authProxyClient *sharedAccountPkg.SysAccountProxyServiceClient
	store           *coredb.CoreDB
	Cfg             *service.ModDiscoConfig
	bus             *sharedBus.CoreBus
	logger          *logrus.Entry
}

func NewModDiscoServiceConfig(l *logrus.Entry, db *coredb.CoreDB, discoCfg *service.ModDiscoConfig, bus *sharedBus.CoreBus, grpcClientOpts grpc.ClientConnInterface) (*ModDiscoServiceConfig, error) {
	if db == nil {
		return nil, fmt.Errorf("error creating mod disco service: database is null")
	}
	modDiscoLogger := l.WithFields(logrus.Fields{
		"mod": "mod-disco",
	})
	newAuthProxyClient := sharedAccountPkg.NewSysAccountProxyServiceClient(grpcClientOpts)
	mdsc := &ModDiscoServiceConfig{
		store:           db,
		Cfg:             discoCfg,
		bus:             bus,
		logger:          modDiscoLogger,
		authProxyClient: newAuthProxyClient,
	}
	return mdsc, nil
}

func NewModDiscoService(cfg *ModDiscoServiceConfig, allDb *coredb.AllDBService) (*ModDiscoService, error) {
	cfg.logger.Infoln("Initializing Mod-Disco Service")
	fileDb, err := coredb.NewCoreDB(cfg.logger, &cfg.Cfg.ModDiscoConfig.SysFileConfig, nil)
	if err != nil {
		return nil, err
	}
	cfg.logger.Infoln("registering mod-disco db & filedb to allDb service")
	allDb.RegisterCoreDB(fileDb)
	allDb.RegisterCoreDB(cfg.store)
	fileRepo, err := corefile.NewSysFileRepo(fileDb, cfg.logger)
	if err != nil {
		return nil, err
	}
	discoRepo, err := repo.NewDiscoRepo(cfg.logger, cfg.store, cfg.Cfg, cfg.bus, cfg.authProxyClient, fileRepo)
	if err != nil {
		return nil, err
	}
	discoService := discoRpc.NewSurveyServiceService(discoRepo)
	modDiscoMetrics := telemetry.NewModDiscoMetrics(cfg.logger)
	return &ModDiscoService{
		proxyService:      discoService,
		ModDiscoRepo:      discoRepo,
		ClientInterceptor: discoRepo.ClientInterceptor,
		BusinessTelemetry: modDiscoMetrics,
	}, nil
}

func (mds *ModDiscoService) RegisterServices(srv *grpc.Server) {
	discoRpc.RegisterSurveyServiceService(srv, mds.proxyService)
}
