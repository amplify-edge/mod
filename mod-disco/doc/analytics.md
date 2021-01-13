# Analytics

I think its best if we just store events and display them in Flutter.

For now we only want the absolute basics for V2 !!


## Analytics for v2

Golang genji / Badger DB records all events.
- the idea is that we introduce a new Badger DB type called "Telemetry".
	- we currently have a Badger db for "Files", "Data"
	- Telemetry DB will be Genjo based like all others.
	- Its NOT a timeseries DB. Just record the events we want with no schema.
	- Queries are just iterations over the Events to produce the Aggregations needed at runtime. BadgerDB is fast so it will be fine.
		- For V3, we can make it more of a CQRS design where the aggregations are recorded in the DB using Benthos to take the event and update the aggregations table(s)
- API is GPRC like everything else in the Architecture.
- Just add the RPC to the exisiting Modules GRPC, so that we dont have to do any extra plumbing
	- SO free CLI for it like everything else.
	- SO CLI can be used to download the CSV of the Telemtry based on the query.
- Config
	- All Modules get a Telemetry DB, just like the other DB's, so its common.
- Developer OPS
	- For v3 / v4 we can use the same system for Ops telemtry. After all the whole idea of this product is to be independent of the cloud and so the Telemetry needs to be part of the system itself
	- Will almost definitly use Open Telemtry: https://github.com/open-telemetry/opentelemetry-go


https://github.com/timshannon/badgerhold#aggregate-queries

https://github.com/sipcapture/homer-app

https://github.com/faceair/VictoriaLogs
- fork: https://github.com/adubovikov/VictoriaLogs
- https://github.com/VictoriaMetrics/VictoriaMetrics/blob/master/app/vmrestore/main.go



Event Logic

- sys-account.
	- event for when a user joins, leaves.
		- Extra Info: Org, Project
	- Event for role
		- Basically when they change roles for a Org / Project.
- mod-disco.
	- event for when a user enrols and what are their supplies and demands.
		- extra info: Supply is a name and the value is a numner (any uom like hrs). E.G "Childcare; 5 hrs."
		- extra info: Needs is a name, with no value, and so its just a boolean- E.G "Legal Help; 1"

Query Logic

- sys-accounts
	- Chart over time, showing user event counts
		- Filters: Org, Project
- mod-disco
	- Chart over time, showing enrollments event counts ( enrolled, unenrolled)
		- Filters:  Org, Project, supply and needs.
- global event filters ( and event data)
	- location ( lat, long )

- CSV
	- For every query we also need to be able to also download the data as a CSV so it can be used in external systems.
	- SO its just the same GRPC query but then converted to CSV and turned into a file download in the GUI.
	- For the CLI, its just the same data. NOT CSV. So you can test the system over the CLI.
		- Propably needs to have pagination. So that will require the pagination to be part of the GRPC API.

Chart types

- Responsiveness
	- Must work with our responsive framework.
	- No idea how a chart can do that. syncfusion shortens the  X axis and y axis i noticed.

- Maps
	- would be useful to show "heat map circles" on a map.
- Bar
	- standars
- Others 
	- Not sure.. Need advice.

flutter charts

- found via dart pub !

- https://github.com/search?l=Dart&o=desc&q=syncfusion_flutter_charts&s=indexed&type=Code
	- code: https://github.com/imaNNeoFighT/fl_chart
	- No web demos.

- https://github.com/entronad/graphic
	- no web demos.

- syncfusion_flutter_charts
	- code: https://github.com/syncfusion/flutter-widgets/tree/master/packages/syncfusion_flutter_charts#get-the-demo-application
	- web: https://flutter.syncfusion.com/#/
	- users: https://github.com/search?l=Dart&o=desc&q=syncfusion_flutter_charts&s=indexed&type=Code
		- heaps !





## Telemetry for v3

Some aspects of this might be worth using now for v2, but we dont have time.

Because the product is a secure self hosted thing, we need to have self hosted telemtry.

Basically the approach is a side car approach.

Metrics

- Here is an example of this approach: https://github.com/mr-karan/store-exporter/
- Motivation: https://github.com/mr-karan/store-exporter#motivation
- Each Module stores its own metrics, and we export it in Prom format IF we need to to the useful tools. But the point is that we can also use FLutter as a GUI for them too.
- Business metrics are also stored in the Module itself and exposed to Flutter because its business stuff.

Tracing

- Can use BadgerDB for storgae now. This solves that aspect for us.
- https://github.com/jaegertracing/jaeger/tree/master/plugin/storage/badger
- docs: https://www.jaegertracing.io/docs/1.12/deployment/#badger---local-storage
- Open Telemetry with Badger store is supported: https://github.com/jaegertracing/jaeger/blob/master/cmd/opentelemetry/app/exporter/badgerexporter/factory.go#L28
	- SO now we can use it.
- Thee is a strong relationshop to the Campaign.md file because we want to trace the Messages that are being send and received via the Messengers for the Business Analytics, not just for OPS. I think that The same tracing badger DB backend can be for the Biz analytics and surfaced via Flutter.

Logging

https://github.com/grafana/loki
- easy to run and embed
	- https://github.com/grafana/loki/blob/master/cmd/loki/main.go
	- https://github.com/grafana/loki/blob/master/cmd/loki/loki-local-config.yaml
- has a WAL recently added. so good option.
- TUI: https://github.com/owen-d/louis
	- nice




## rudderstack

https://rudderstack.com/

https://github.com/rudderlabs/rudder-server
