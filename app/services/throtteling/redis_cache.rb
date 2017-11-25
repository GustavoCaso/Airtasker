module Throtteling
  class RedisCache
    attr_reader :store
    def initialize(store = REDIS)
      @store = store
    end

    def write(key, value, opts = {})
      store.set(key, value)
      store.expire(key, opts[:period])
    end

    def increment(key)
      store.incr(key)
    end

    def read(key)
      store.get(key)
    end

    def time_to_live(key)
      store.ttl(key)
    end
  end
end
