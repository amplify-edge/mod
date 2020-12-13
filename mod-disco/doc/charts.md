# charts

For now we only want the absolute basics for V2 !!


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

- Maps
	- would be useful to show "heat map circles" on a map.
- Bar
	- standars
- Others 
	- Not sure.. Need advice.

flutter charts
- https://github.com/imaNNeoFighT/fl_chart
	- No web demos.

- code: https://github.com/syncfusion/flutter-widgets/tree/master/packages/syncfusion_flutter_charts#get-the-demo-application
	- web: https://flutter.syncfusion.com/#/
	- commervial so we cant use these !

