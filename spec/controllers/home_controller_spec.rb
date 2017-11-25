class TestHomeController < ActionController::Base
  before_action :limit_requests

  include Concerns::Throttler

  Throtteling::Registry.throttle(
    'test_rate',
    limit: 1,
    period: 60,
    cache: TestingCache.new
  )

  def index
    render plain: 'ok'
  end

  private

  def limit_requests
    throttled?('test_rate', identifier: request.ip)
  end
end

RSpec.describe TestHomeController, type: :controller do
  after do
    Throtteling::Registry.delete('test_rate') # To avoid poluting global registry
  end

  before do
    routes.draw { get 'index' => 'test_home#index' }
  end

  describe 'limiting request' do
    it 'return 429 when limit is reached' do
      get :index
      expect(response.body).to eq 'ok'

      get :index
      expect(response.status).to eq 429
      expect(response.body).to eq 'Rate limit exceeded. Try again in 60 seconds'
    end
  end
end
