module Concerns
  module Throttler
    extend ActiveSupport::Concern

    included do
      Throtteling::Registry.throttle(
        'rate_limit_100_request_per_hour',
        limit: 100,
        period: 60 * 60,
        cache: Throtteling::RedisCache.new
      )
    end

    def register_throttle(name, opts)
      Throtteling::Registry.throttle(name, opts)
    end

    def get_throttle(key, identifier: nil)
      Throtteling::Registry[key]
        .with(identifier: identifier)
    end

    def throttled?(key, identifier: nil)
      throttle_action = get_throttle(key, identifier: identifier)
      render status: Throtteling::Throttle::STATUS_ERROR, plain: throttle_action.error_message if throttle_action.throttled?
    end
  end
end
