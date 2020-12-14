# db-migrations

we have none and we really need them.

https://github.com/golang-migrate/migrate
- looks good because its independent of SQL drivers and so then easy to use with anything.

We also need all data layers to be able to run as a Service. 
- Use GRPC, as its our way to go as a singel binary or many.
- SQL over GRPC.
- All the SQL utils Alex wrote can be used by the Modules still ? I think its genji independent ? check with him.
- Why ?
	- SO we can built faster.
	- SO devs can just write SQL Mutations and Queries, and the CQRS stuff is abstracted. That is the whole point of the product.
		- The whole poit is:
			- Make a query and subscribe.
			- Make a mutation, and let it ripple through the system, making query subscriptions fire off change events.
			- Add a Proto and let the Sql Layer reflect on it.


File DB
- https://github.com/creachadair/badgerstore
	- has alot of stuff we dont have. Chunking, etc
	- Interface matches the Google Store which we need: https://github.com/creachadair/gcsstore
		- This will make backups that are differential much easier.