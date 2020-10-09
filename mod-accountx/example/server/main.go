// package main
package main

import (
	/*
		"context"

		"net/http"
		"os"
		"time"

		grpc_middleware "github.com/grpc-ecosystem/go-grpc-middleware"
		grpc_auth "github.com/grpc-ecosystem/go-grpc-middleware/auth"
		grpc_logrus "github.com/grpc-ecosystem/go-grpc-middleware/logging/logrus"
		grpc_recovery "github.com/grpc-ecosystem/go-grpc-middleware/recovery"
		"github.com/improbable-eng/grpc-web/go/grpcweb"

		"github.com/sirupsen/logrus"
		"golang.org/x/net/http2"
		"golang.org/x/net/http2/h2c"
		"google.golang.org/grpc"
		"google.golang.org/grpc/reflection"
	*/

	proxy "github.com/getcouragenow/sys-share/main/pkg"

	pkg "github.com/getcouragenow/mod/mod-account/server/pkg"
)

// Invoke ...
func Invoke() string {

	// load up the Sys-share GRPC Services proxy

	fmt.Println("In mod-account GRPC Server.")

	fmt.Println("Calling sys-share GRPC Services Proxy.")
	return proxy.Invoke()
}
