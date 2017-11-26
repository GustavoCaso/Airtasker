class HomeController < ApplicationController
  before_action :limit_number_of_requests

  def index
    render plain: 'ok'
  end

  def limit_number_of_requests
    throttled?('rate_limit_100_request_per_hour', identifier: request.ip)
  end
end
