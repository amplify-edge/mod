# charts

Golang genji / Badger DB records all events.
- simple table of events
- aggrgeations are calculated by iterating over records via a query.
- APi using GPRC like everything else.
- so the idea is that we introduce a new Badger DB type called "telemetry"
- for V2 we just want to do if for what is needed for V2, but we can then use this for all modules, with each module having an telemetry aspect
- for maybe v3 / v4 we can use the same system for Ops telemtry. After all the whole idea of this product is to be independent of the cloud and so the Telemetry needs to be part of the system itself

Event Logic
- event for when a user joins, leaves. This is from sys-account
- event for when a user enrols and what are their supplies and demands- this is form mod-disco.
	- Supply is a name and the value is a numner (any uom like hrs)
	- Needs is a name, with no value, and so its just a boolean

Query Logic
- This is all determiend by what info we need to display inthe charts
- For every query we also need to be able to also download the data as a CS so it can be used in external systems.
	- SO its just the same GRPC query but then converted to CSV and turned into a file download in the GUI.
	- Every chart will then have a download icon.
- Queries for sys-accounts
	- Chart over time, showing user count
	- Filters: Org, Project.
- Queries for mod-disco
	- Chart over time, showing enrollments and supple and needs

	- Chart showing over time the users

flutter
- d

examples
code: https://github.com/syncfusion/flutter-widgets/tree/master/packages/syncfusion_flutter_charts#get-the-demo-application
web: https://flutter.syncfusion.com/#/


