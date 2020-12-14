# campaign

For V3 one of the first things we need is a campaing system.

They typically have a segment system.

https://github.com/knadh/listmonk
- segment system that is flexible: 
	- https://listmonk.app/docs/concepts/#attributes
	- https://listmonk.app/docs/querying-and-segmentation/
- has different messengers: https://listmonk.app/docs/messengers/
- smtp pool
- Has editor for usrs to craft messages: https://listmonk.app/docs/templating/
- DB
	- it uses postresql, and we need to use genji. Genjo matches it because of the schemaless JSONB architecture that the segments and templates use.
	- other option is to use cockroachDB in embedded mode:
		- https://github.com/cockroachdb/cockroach/blob/master/pkg/server/testserver.go
- BUT bad things
	- ZERO Tests....
	- CLI is messy stuff
	- written like its by system admins, and not golang coders. Very loose.
- Wrapping
	- I think grpc wrapping would be smart.
	- GUI 100% in flutter talking to GRPC, and then their stuff. Closes it up nicely.



## Messengers

twitter
- https://github.com/creachadair/twig
- uses the NEW experimental Twitter API: https://developer.twitter.com/en/docs/twitter-api/early-access

