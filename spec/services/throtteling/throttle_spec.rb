RSpec.describe Throtteling::Throttle do
  subject { described_class }
  let(:throttle) { described_class.new(1, 3, TestingCache.new, 'test') }

  describe '#with' do
    it 'returns a new throttle with a new identifier' do
      new_throttle = throttle.with(identifier: 'test_2')
      expect(new_throttle).to_not eq throttle
      expect(new_throttle.identifier).to eq 'test_2'
    end

    it 'returns the same throttle if no identifier is passed' do
      new_throttle = throttle.with
      expect(new_throttle).to eq throttle
      expect(new_throttle.identifier).to eq 'test'
    end
  end

  describe '#error_message' do
    it 'returns error_message with how long have to wait until the throttle has lift up' do
      expect(throttle.error_message).to eq 'Rate limit exceeded. Try again in 3 seconds'
    end
  end

  describe '#throttled?' do
    it 'returns false if we can continue or true if we are blocked' do
      results = { '0' => nil, '1' => nil }
      2.times do |x|
        results[x.to_s] = throttle.throttled?
      end

      expect(results['0']).to eq false
      expect(results['1']).to eq true
    end
  end
end
