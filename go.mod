module github.com/amplify-cms/mod

go 1.15

require (
	github.com/DataDog/zstd v1.4.5 // indirect
	github.com/Masterminds/squirrel v1.4.0
	github.com/VictoriaMetrics/metrics v1.12.3
	github.com/amplify-cms/protoc-gen-cobra v0.3.1-0.20210203065653-3c0be935c016
	github.com/amplify-cms/sys v0.0.0-20201230052306-22a6aaf34655
	github.com/amplify-cms/sys-share v0.0.0-20201231111816-770029a76658
	github.com/brianvoe/gofakeit/v5 v5.11.2
	github.com/dgraph-io/ristretto v0.0.3 // indirect
	github.com/dgryski/go-farm v0.0.0-20200201041132-a6ae2369ad13 // indirect
	github.com/genjidb/genji v0.9.0
	github.com/golang/protobuf v1.4.3
	github.com/golang/snappy v0.0.2 // indirect
	github.com/google/go-cmp v0.5.2
	github.com/segmentio/encoding v0.2.7
	github.com/spf13/cobra v1.1.1
	github.com/stretchr/testify v1.7.0
	google.golang.org/appengine v1.6.7 // indirect
	google.golang.org/grpc v1.35.0
	google.golang.org/protobuf v1.25.0
	gopkg.in/yaml.v2 v2.3.0
)

replace github.com/amplify-cms/sys-share => ../sys-share/

replace github.com/amplify-cms/sys => ../sys
