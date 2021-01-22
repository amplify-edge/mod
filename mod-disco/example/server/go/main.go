package main

import (
	"github.com/getcouragenow/sys-share/sys-core/service/logging"
	"github.com/getcouragenow/sys-share/sys-core/service/logging/zaplog"
	"github.com/spf13/cobra"
)

const (
	errSourcingConfig   = "error while sourcing config for %s: %v"
	errCreateSysService = "error while creating sys-%s service: %v"

	defaultAddr               = "127.0.0.1"
	defaultPort               = 8889
	defaultModDiscoConfigPath = "./bin-all/config/moddisco.yml"
)

var (
	rootCmd      = &cobra.Command{Use: "mod-disco-srv"}
	discoCfgPath string
)

func recoveryHandler(l logging.Logger) func(panic interface{}) error {
	return func(panic interface{}) error {
		l.Warnf("mod-disco service recovered, reason: %v",
			panic)
		return nil
	}
}

func main() {
	rootCmd.PersistentFlags().StringVarP(&discoCfgPath, "mod-disco-config-path", "c", defaultModDiscoConfigPath, "mod-disco config path to use")

	log := zaplog.NewZapLogger("debug", "mod-disco-example", true)
	log.InitLogger(nil)

	rootCmd.RunE = func(cmd *cobra.Command, args []string) error {
		//	discoCfg, err := service.NewConfig(discoCfgPath)
		//	if err != nil {
		//		log.Fatalf(errSourcingConfig, err)
		//	}
		//
		//	log.Warnf("DB Config: %v", discoCfg.ModDiscoConfig.SysCoreConfig)
		//	gdb, err := coredb.NewCoreDB(log, &discoCfg.ModDiscoConfig.SysCoreConfig, nil)
		//	if err != nil {
		//		log.Fatalf(errSourcingConfig, err)
		//	}
		//
		//	discoServiceCfg, err := pkg.NewModDiscoServiceConfig(log, gdb, discoCfgPath, corebus.NewCoreBus(), nil)
		//	if err != nil {
		//		log.Fatalf("error creating config: %v", err)
		//	}
		//
		//	svc, err := pkg.NewModDiscoService(discoServiceCfg)
		//	if err != nil {
		//		log.Fatalf("error creating mod-disco service: %v", err)
		//	}
		//
		//	recoveryOptions := []grpcRecovery.Option{
		//		grpcRecovery.WithRecoveryHandler(recoveryHandler(log)),
		//	}
		//
		//	unaryItc := []grpc.UnaryServerInterceptor{
		//		grpcRecovery.UnaryServerInterceptor(recoveryOptions...),
		//		log.GetServerUnaryInterceptor(),
		//	}
		//
		//	streamItc := []grpc.StreamServerInterceptor{
		//		grpcRecovery.StreamServerInterceptor(recoveryOptions...),
		//		log.GetServerStreamInterceptor(),
		//	}
		//
		//	grpcSrv := grpc.NewServer(
		//		grpcMw.WithUnaryServerChain(unaryItc...),
		//		grpcMw.WithStreamServerChain(streamItc...),
		//	)
		//
		//	// Register sys-account service
		//	svc.RegisterServices(grpcSrv)
		//
		//	grpcWebServer := grpcweb.WrapServer(
		//		grpcSrv,
		//		grpcweb.WithCorsForRegisteredEndpointsOnly(false),
		//		grpcweb.WithWebsocketOriginFunc(func(req *http.Request) bool {
		//			return true
		//		}),
		//		grpcweb.WithWebsockets(true),
		//	)
		//
		//	httpServer := &http.Server{
		//		Handler: h2c.NewHandler(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		//			w.Header().Set("Access-Control-Allow-Origin", "*")
		//			w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		//			w.Header().Set("Access-Control-Allow-Headers", "Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, X-User-Agent, X-Grpc-Web")
		//			log.Infof("Request Endpoint: %s", r.URL)
		//			grpcWebServer.ServeHTTP(w, r)
		//		}), &http2.Server{}),
		//	}
		//	httpServer.Addr = fmt.Sprintf("%s:%d", defaultAddr, defaultPort)
		//	log.Infof("service listening at %v\n", httpServer.Addr)
		//	return httpServer.ListenAndServe()
		//}
		//
		//if err := rootCmd.Execute(); err != nil {
		//	log.Fatal(err)
		//}
		return nil
	}
}
