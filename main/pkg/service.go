package pkg

import (
	"fmt"
	// pkg "github.com/getcouragenow/sys/main/pkg"
	pkg "github.com/getcouragenow/sys/main/pkg"
)

// Invoke ...
func Invoke() string {
	// load up the sub grpc Services proxy

	fmt.Println("mod-pkg GRPC Services")

	return "hello from mod-pkg GRPC Services"

}
