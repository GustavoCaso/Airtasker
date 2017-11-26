RSpec.describe Throtteling::Registry do
  subject { described_class }
  let(:cache) { Object.new }

  after do
    subject.delete('test_mode') # To avoid poluting global registry
  end

  describe '#throttle' do
    it 'register a new throttle' do
      expect(Throtteling::Throttle).to receive(:new).with(1, 1, cache, 'test')
      subject.throttle('test_mode', period: 1, limit: 1, cache: cache, identifier: 'test')
    end

    it 'stores in the register by name' do
      subject.throttle('test_mode', period: 1, limit: 1, cache: cache, identifier: 'test')
      expect(subject.throttles.keys).to include 'test_mode'
    end
  end

  describe '#delete' do
    before do
      subject.throttle('test_mode', period: 1, limit: 1, cache: cache, identifier: 'test')
    end

    it 'deletes throttle from registry' do
      subject.delete('test_mode')
      expect(subject.throttles.keys).to_not include 'test_mode'
    end
  end

  describe '#[]' do
    it 'fetchs throttle by name' do
      subject.throttle('test_mode', period: 1, limit: 1, cache: cache, identifier: 'test')
      expect(subject['test_mode']).to be_a Throtteling::Throttle
    end

    it 'raises an error if no throttle found' do
      expect {
        subject['invalid_name']
      }.to raise_error(Throtteling::Registry::InvalidThrottlerName)
    end
  end
end
