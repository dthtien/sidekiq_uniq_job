# Professor Gray's Satellite Data Processing

Greetings meatbag! Er, I mean, fellow human.

Recently, the satellite data as processed by my application is having some problems with its correctness. It looks like the telescopes are sometimes enqueueing the same data twice. We need to be able to deal with this, as I can't reach the coders responsible for enqueueing the data.

I've provided my application here. As before, you can start it with `$ foreman start`.

**You must have Postgres database server running for this assignment.**

Here are the requirements:

1. Each combination of `[data_point, type]` arguments should only execute once.
2. The completion hash logged at the end of the application must be: `2dbea0c8effb0e3a57a7bbe501db79e5`
3. You may only change `app.rb`.
4. The entire workload must complete in less than 5 seconds.