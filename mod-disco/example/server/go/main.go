package main

import (
	"fmt"
	service "github.com/getcouragenow/mod/mod-disco/service/go"
	pkg "github.com/getcouragenow/mod/mod-disco/service/go/pkg"
	corebus "github.com/getcouragenow/sys-share/sys-core/service/go/pkg/bus"
	"github.com/getcouragenow/sys/sys-core/service/go/pkg/coredb"
	grpcMw "github.com/grpc-ecosystem/go-grpc-middleware"
	grpcLogrus "github.com/grpc-ecosystem/go-grpc-middleware/logging/logrus"
	grpcRecovery "github.com/grpc-ecosystem/go-grpc-middleware/recovery"
	"github.com/improbable-eng/grpc-web/go/grpcweb"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/grpc"
	"net/http"
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

func recoveryHandler(l *logrus.Entry) func(panic interface{}) error {
	return func(panic interface{}) error {
		l.Warnf("mod-disco service recovered, reason: %v",
			panic)
		return nil
	}
}

func main() {
	rootCmd.PersistentFlags().StringVarP(&discoCfgPath, "mod-disco-config-path", "c", defaultModDiscoConfigPath, "mod-disco config path to use")

	logr := logrus.New()
	logr.SetLevel(logrus.DebugLevel)
	log := logr.WithField("mod", "disco")

	rootCmd.RunE = func(cmd *cobra.Command, args []string) error {
		discoCfg, err := service.NewConfig(discoCfgPath)
		if err != nil {
			log.Fatalf(errSourcingConfig, err)
		}

		log.Warnf("DB Config: %v", discoCfg.ModDiscoConfig.SysCoreConfig)
		gdb, err := coredb.NewCoreDB(log, &discoCfg.ModDiscoConfig.SysCoreConfig, nil)
		if err != nil {
			log.Fatalf(errSourcingConfig, err)
		}

		discoServiceCfg, err := pkg.NewModDiscoServiceConfig(log, gdb, discoCfgPath, corebus.NewCoreBus())
		if err != nil {
			log.Fatalf("error creating config: %v", err)
		}

		svc, err := pkg.NewModDiscoService(discoServiceCfg)
		if err != nil {
			log.Fatalf("error creating mod-disco service: %v", err)
		}

		recoveryOptions := []grpcRecovery.Option{
			grpcRecovery.WithRecoveryHandler(recoveryHandler(log)),
		}

		logrusOpts := []grpcLogrus.Option{
			grpcLogrus.WithLevels(grpcLogrus.DefaultCodeToLevel),
		}

		unaryItc := []grpc.UnaryServerInterceptor{
			grpcRecovery.UnaryServerInterceptor(recoveryOptions...),
			grpcLogrus.UnaryServerInterceptor(log, logrusOpts...),
		}

		streamItc := []grpc.StreamServerInterceptor{
			grpcRecovery.StreamServerInterceptor(recoveryOptions...),
			grpcLogrus.StreamServerInterceptor(log, logrusOpts...),
		}

		grpcSrv := grpc.NewServer(
			grpcMw.WithUnaryServerChain(unaryItc...),
			grpcMw.WithStreamServerChain(streamItc...),
		)

		// Register sys-account service
		svc.RegisterServices(grpcSrv)

		grpcWebServer := grpcweb.WrapServer(
			grpcSrv,
			grpcweb.WithCorsForRegisteredEndpointsOnly(false),
			grpcweb.WithWebsocketOriginFunc(func(req *http.Request) bool {
				return true
			}),
			grpcweb.WithWebsockets(true),
		)

		httpServer := &http.Server{
			Handler: h2c.NewHandler(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				w.Header().Set("Access-Control-Allow-Origin", "*")
				w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
				w.Header().Set("Access-Control-Allow-Headers", "Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, X-User-Agent, X-Grpc-Web")
				log.Infof("Request Endpoint: %s", r.URL)
				grpcWebServer.ServeHTTP(w, r)
			}), &http2.Server{}),
		}
		httpServer.Addr = fmt.Sprintf("%s:%d", defaultAddr, defaultPort)
		log.Infof("service listening at %v\n", httpServer.Addr)
		return httpServer.ListenAndServe()
	}

	if err := rootCmd.Execute(); err != nil {
		log.Fatal(err)
	}
}
