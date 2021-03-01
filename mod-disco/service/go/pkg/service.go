package pkg

import (
	"fmt"
	accountRpc "go.amplifyedge.org/sys-share-v2/sys-account/service/go/rpc/v2"
	"go.amplifyedge.org/sys-share-v2/sys-core/service/logging"
	"google.golang.org/grpc"

	"go.amplifyedge.org/mod-v2/mod-disco/service/go/pkg/telemetry"
	corefile "go.amplifyedge.org/sys-v2/sys-core/service/go/pkg/filesvc/repo"

	service "go.amplifyedge.org/mod-v2/mod-disco/service/go"
	"go.amplifyedge.org/mod-v2/mod-disco/service/go/pkg/repo"
	discoRpc "go.amplifyedge.org/mod-v2/mod-disco/service/go/rpc/v2"
	"go.amplifyedge.org/sys-share-v2/sys-account/service/go/pkg/interceptor"
	sharedBus "go.amplifyedge.org/sys-share-v2/sys-core/service/go/pkg/bus"
	"go.amplifyedge.org/sys-v2/sys-core/service/go/pkg/coredb"
)

type ModDiscoService struct {
	Service           discoRpc.SurveyServiceServer
	ClientInterceptor *interceptor.ClientSide
	ModDiscoRepo      *repo.ModDiscoRepo
	BusinessTelemetry *telemetry.ModDiscoMetrics
}

type ModDiscoServiceConfig struct {
	authClient accountRpc.AuthServiceClient
	store      *coredb.CoreDB
	Cfg        *service.ModDiscoConfig
	bus        *sharedBus.CoreBus
	logger     logging.Logger
}

func NewModDiscoServiceConfig(l logging.Logger, db *coredb.CoreDB, discoCfg *service.ModDiscoConfig, bus *sharedBus.CoreBus, grpcClientOpts grpc.ClientConnInterface) (*ModDiscoServiceConfig, error) {
	if db == nil {
		return nil, fmt.Errorf("error creating mod disco service: database is null")
	}
	modDiscoLogger := l.WithFields(map[string]interface{}{"service": "mod-disco"})
	newAuthClient := accountRpc.NewAuthServiceClient(grpcClientOpts)
	mdsc := &ModDiscoServiceConfig{
		store:      db,
		Cfg:        discoCfg,
		bus:        bus,
		logger:     modDiscoLogger,
		authClient: newAuthClient,
	}
	return mdsc, nil
}

func NewModDiscoService(cfg *ModDiscoServiceConfig, allDb *coredb.AllDBService) (*ModDiscoService, error) {
	cfg.logger.Info("Initializing Mod-Disco Service")
	fileDb, err := coredb.NewCoreDB(cfg.logger, &cfg.Cfg.SysFileConfig, nil)
	if err != nil {
		return nil, err
	}
	cfg.logger.Info("registering mod-disco db & filedb to allDb service")
	allDb.RegisterCoreDB(fileDb)
	allDb.RegisterCoreDB(cfg.store)
	fileRepo, err := corefile.NewSysFileRepo(fileDb, cfg.logger)
	if err != nil {
		return nil, err
	}
	discoRepo, err := repo.NewDiscoRepo(cfg.logger, cfg.store, cfg.Cfg, cfg.bus, cfg.authClient, fileRepo)
	if err != nil {
		return nil, err
	}
	modDiscoMetrics := telemetry.NewModDiscoMetrics(cfg.logger)
	return &ModDiscoService{
		Service:           discoRepo,
		ModDiscoRepo:      discoRepo,
		ClientInterceptor: discoRepo.ClientInterceptor,
		BusinessTelemetry: modDiscoMetrics,
	}, nil
}

func (mds *ModDiscoService) RegisterServices(srv *grpc.Server) {
	discoRpc.RegisterSurveyServiceServer(srv, mds.Service)
}
