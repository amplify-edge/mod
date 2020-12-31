module github.com/getcouragenow/mod

go 1.15

require (
	github.com/DataDog/zstd v1.4.5 // indirect
	github.com/Masterminds/squirrel v1.4.0
	github.com/brianvoe/gofakeit/v5 v5.9.3
	github.com/dgraph-io/ristretto v0.0.3 // indirect
	github.com/dgryski/go-farm v0.0.0-20200201041132-a6ae2369ad13 // indirect
	github.com/genjidb/genji v0.9.0
	github.com/getcouragenow/protoc-gen-cobra v0.3.1-0.20201005114840-ccc8cd57bcdc
	github.com/getcouragenow/sys v0.0.0-20201230052306-22a6aaf34655
	github.com/getcouragenow/sys-share v0.0.0-20201231111816-770029a76658
	github.com/golang/protobuf v1.4.3
	github.com/golang/snappy v0.0.2 // indirect
	github.com/google/go-cmp v0.5.1
	github.com/grpc-ecosystem/go-grpc-middleware v1.2.2
	github.com/improbable-eng/grpc-web v0.13.0
	github.com/segmentio/encoding v0.2.2
	github.com/sirupsen/logrus v1.7.0
	github.com/spf13/cobra v1.1.1
	github.com/spf13/pflag v1.0.5
	github.com/stretchr/testify v1.6.1
	golang.org/x/net v0.0.0-20201110031124-69a78807bb2b
	golang.org/x/oauth2 v0.0.0-20200902213428-5d25da1a8d43
	golang.org/x/sys v0.0.0-20201029080932-201ba4db2418 // indirect
	google.golang.org/appengine v1.6.7 // indirect
	google.golang.org/grpc v1.33.2
	google.golang.org/protobuf v1.25.0
	gopkg.in/yaml.v2 v2.3.0
)

replace github.com/getcouragenow/sys-share => ../sys-share/

replace github.com/getcouragenow/sys => ../sys
