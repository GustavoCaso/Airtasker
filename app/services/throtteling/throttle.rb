module Throtteling
  # Based on a limit and a time window will return if the identifier has exceeded
  # the number of permitted entries
  #
  # The cache can be any instance that response to #read, #write and #increment optional
  # can response to #time_to_live to return the time left before the block is lifted
  #
  class Throttle
    STATUS_ERROR = 429

    attr_reader :limit, :period, :cache, :identifier

    def initialize(limit, period, cache, identifier)
      @limit = limit
      @period = period
      @cache = cache
      @identifier = identifier
    end

    def with(identifier: nil)
      return self unless identifier
      self.class.new(limit, period, cache, identifier)
    end

    def throttled?
      return false unless identifier
      return true if block_key

      count = identifier_key
      unless count
        initialize_counter
        return false
      end

      if count.to_i >= limit
        block_key!
        return true
      end
      increment_key!
      false
    end

    def error_message
      "Rate limit exceeded. Try again in #{expire_at(blocked_key)} seconds"
    end

    private

    def key
      @key ||= "throttle:#{identifier}"
    end

    def blocked_key
      @blocked_key = "throttle:locked:#{identifier}"
    end

    def identifier_key
      cache.read(key)
    end

    def block_key
      cache.read(blocked_key)
    end

    def initialize_counter
      cache.write(key, 1, period: period)
    end

    def block_key!
      cache.write(blocked_key, 1, period: period)
    end

    def increment_key!
      cache.increment(key)
    end

    def expire_at(key)
      if cache.respond_to?(:time_to_live)
        cache.time_to_live(key)
      else
        period
      end
    end
  end
end
