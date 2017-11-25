class TestingCache
  attr_reader :store

  def initialize
    @store = {}
  end

  def read(key)
    store[key]
  end

  def write(key, value, options)
    store[key] = value

    # To simulate the expiration functionality from redis
    Thread.new do
      sleep options[:period]
      store.tap { |st| st.delete(key) }
    end
  end

  def increment(key)
    store[key] = store[key] + 1
  end
end
