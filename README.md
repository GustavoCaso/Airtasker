### Implement a rate limit solution

Implemnt a rate limit solution for a Rails application.

The target of the solution is at the controller level.

You can register as many Throttling rules as you need, and you can apply them to any route required.

Added a Throttle registry, a cache interface so you can use any store you want, for each throttle rule.

The cache interface is pretty simple it simple, it must respond to `write`, `read` and `increment`, optionally it can respond to `time_to_live` to return the number of seconds before it can access the application.

After looking for multiple solutions out there, I concluded that there multiple approaches to this problem, creating a Rack Middleware or implementing an in-house solution (this example).

Both of solutions have benefits and limitations.

## Setup

You need to have installed `redis`

`$ brew install redis`

To start the application, we need `redis` running in the backgrouond

`$ redis-server`


`$ bundle exec rails s`

With this go to the root `http;//localhost:3000` you should see a `ok` in the page

To force the rate limit to return a `429` status response and a message

You can use:

```
for i in {1..100}
do
curl -i http://localhost:3000 >> /dev/null
done
```

Then visiting the root again should appear a message we have hit our limit
