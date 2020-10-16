package pkg

import (
	"context"
	"fmt"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"log"
	"net/http"

	"github.com/improbable-eng/grpc-web/go/grpcweb"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"google.golang.org/grpc"

	dummypkg "github.com/getcouragenow/mod/mod-dummy/service/go/pkg"
	syspkg "github.com/getcouragenow/sys-share/sys-account/service/go/pkg"
)

const (
	errRunningServer = "error running grpc & grpc web service: %v"
)


var rootCmd = &cobra.Command{
	Use: "mod-main",
}

// Invoke ...
func ModCli() *cobra.Command {
	// load up the sub grpc Services proxy

	log.Println(" -- mod proxy cli -- ")

	// load up mod-cli client
	log.Println(" -- Load Mod cli -- ")
	dummyCliClient := dummypkg.NewModDummyProxyClient()

	// Add it to root cobra
	rootCmd.AddCommand(dummyCliClient.CobraCommand())

	return rootCmd
}

type ModService struct {
	port              int
	logger            *logrus.Entry
	serverInterceptor func(context.Context) (context.Context, error)
	dummySvc          *dummypkg.ModDummyProxyService
}

func NewModService(
	l *logrus.Entry,
	port int, accountSvc syspkg.AccountService,
	authSvc syspkg.AuthService, grpcConn grpc.ClientConnInterface,
	interceptor func(context.Context) (context.Context, error),
) (*ModService, error) {
	dummyRepo, err := dummypkg.NewModDummyRepo(grpcConn, accountSvc, authSvc)
	if err != nil {
		return nil, err
	}
	dummySvc := dummypkg.NewModDummyProxyService(dummyRepo)
	return &ModService{
		port:              port,
		logger:            l,
		dummySvc:          dummySvc,
		serverInterceptor: interceptor,
	}, nil
}

func (ms *ModService) InjectInterceptors(unaryInterceptors []grpc.UnaryServerInterceptor, streamInterceptors []grpc.StreamServerInterceptor) ([]grpc.UnaryServerInterceptor, []grpc.StreamServerInterceptor) {
	//unaryItc := append(unaryInterceptors, grpcAuth.UnaryServerInterceptor(ms.serverInterceptor))
	//streamItc := append(streamInterceptors, grpcAuth.StreamServerInterceptor(ms.serverInterceptor))
	//return unaryItc, streamItc
	return unaryInterceptors, streamInterceptors
}

func (ms *ModService) RegisterServices(srv *grpc.Server) {
	ms.dummySvc.RegisterSvc(srv)
}

func (ms *ModService) recoveryHandler() func(panic interface{}) error {
	return func(panic interface{}) error {
		ms.logger.Warnf("mod service recovered, reason: %v",
			panic)
		return nil
	}
}

// Creates a GrpcWeb wrapper around grpc.Server
func (ms *ModService) RegisterGrpcWebServer(srv *grpc.Server) *grpcweb.WrappedGrpcServer {
	return grpcweb.WrapServer(
		srv,
		grpcweb.WithCorsForRegisteredEndpointsOnly(false),
		grpcweb.WithWebsocketOriginFunc(func(req *http.Request) bool {
			return true
		}),
		grpcweb.WithWebsockets(true),
	)
}

// run runs all the sys-* service as a service
func (ms *ModService) run(grpcWebServer *grpcweb.WrappedGrpcServer, httpServer *http.Server) error {
	if httpServer == nil {
		httpServer = &http.Server{
			Handler: h2c.NewHandler(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				w.Header().Set("Access-Control-Allow-Origin", "*")
				w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
				w.Header().Set("Access-Control-Allow-Headers", "Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, X-User-Agent, X-Grpc-Web")
				ms.logger.Infof("Request Endpoint: %s", r.URL)
				grpcWebServer.ServeHTTP(w, r)
			}), &http2.Server{}),
		}
	}

	httpServer.Addr = fmt.Sprintf("127.0.0.1:%d", ms.port)
	return httpServer.ListenAndServe()
}

// Run is just an exported wrapper for s.run()
func (ms *ModService) Run(srv *grpcweb.WrappedGrpcServer, httpServer *http.Server) {
	if err := ms.run(srv, httpServer); err != nil {
		ms.logger.Fatalf(errRunningServer, err)
	}
}
