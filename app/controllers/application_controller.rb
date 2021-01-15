class ApplicationController < ActionController::Base
  include SessionsHelper
  add_flash_types :success, :info, :warning, :danger
  if Rails.env.production?
    http_basic_authenticate_with name: ENV["BASIC_AUTH_USERNAME"],
                                 password: ENV["BASIC_AUTH_PASSWORD"]
  end

  def put_api_error_log(action, status, error)
    logger.error "error_status: #{status}\r#{action}_error: #{error}"
  end
end
