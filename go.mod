module github.com/getcouragenow/mod

go 1.15

require (
	github.com/Masterminds/squirrel v1.4.0
	github.com/genjidb/genji v0.8.0
	github.com/getcouragenow/protoc-gen-cobra v0.3.1-0.20201005114840-ccc8cd57bcdc
	github.com/getcouragenow/sys v0.0.0-20201022153341-38df5aeea810
	github.com/getcouragenow/sys-share v0.0.0-20201026130736-575e968e4348
	github.com/golang/protobuf v1.4.3
	github.com/google/go-cmp v0.5.1
	github.com/grpc-ecosystem/go-grpc-middleware v1.2.2
	github.com/improbable-eng/grpc-web v0.13.0
	github.com/segmentio/encoding v0.2.0
	github.com/sirupsen/logrus v1.7.0
	github.com/spf13/cobra v1.0.0
	github.com/spf13/pflag v1.0.5
	github.com/stretchr/testify v1.6.1
	golang.org/x/net v0.0.0-20201029221708-28c70e62bb1d
	golang.org/x/oauth2 v0.0.0-20200902213428-5d25da1a8d43
	google.golang.org/grpc v1.32.0
	google.golang.org/protobuf v1.25.0
	gopkg.in/yaml.v2 v2.3.0
)

replace github.com/getcouragenow/sys-share => ../sys-share/

replace github.com/getcouragenow/sys => ../sys
