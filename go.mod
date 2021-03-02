module go.amplifyedge.org/mod-v2

go 1.16

require (
	github.com/Masterminds/squirrel v1.5.0
	github.com/VictoriaMetrics/metrics v1.13.0
	github.com/brianvoe/gofakeit/v5 v5.11.2
	github.com/genjidb/genji v0.10.1
	github.com/golang/protobuf v1.4.3
	github.com/google/go-cmp v0.5.4
	github.com/segmentio/encoding v0.2.7
	github.com/spf13/cobra v1.1.1
	github.com/stretchr/testify v1.7.0
	go.amplifyedge.org/protoc-gen-cobra v0.4.0
	go.amplifyedge.org/sys-share-v2 v0.0.0-00010101000000-000000000000
	go.amplifyedge.org/sys-v2 v0.0.0-00010101000000-000000000000
	google.golang.org/grpc v1.35.0
	google.golang.org/protobuf v1.25.0
	gopkg.in/yaml.v2 v2.4.0
)

replace go.amplifyedge.org/sys-v2 => ../sys/

replace go.amplifyedge.org/sys-share-v2 => ../sys-share
