module Throtteling
  class Registry
    class InvalidThrottlerName < StandardError
      def initialize(name)
        super("Throttle not register #{name}. Please verify your throttles list")
      end
    end

    def self.throttles
      @throttles ||= {}
    end

    def self.[](name)
      throttles.fetch(name) { raise InvalidThrottlerName.new(name) }
    end

    def self.throttle(name, opts = {})
      throttles[name] = Throttle.new(
        opts[:limit],
        opts[:period],
        opts[:cache],
        opts[:identifier]
      )
    end

    def self.delete(name)
      throttles.delete(name)
    end
  end
end
