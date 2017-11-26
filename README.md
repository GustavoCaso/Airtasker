### Implement a rate limit solution

Implemnt a rate limit solution for a Rails application.

The target of the solution is at the controller level.

You can register as many Throttling rules as you need, and you can apply them to any route required.

Added a Throttle registry, a cache interface so you can use any store you want, for each throttle rule.

The cache interface is pretty simple it simple, it must respond to `write`, `read` and `increment`, optionally it can respond to `time_to_live` to return the number of seconds before it can access the application.

After looking for multiple solutions out there, I concluded that there multiple approaches to this problem, creating a Rack Middleware or implementing an in-house solution (this example).

Both of solutions have benefits and limitations.


