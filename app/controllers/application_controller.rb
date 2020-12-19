class ApplicationController < ActionController::Base
  include SessionsHelper
  add_flash_types :success, :info, :warning, :danger
  if Rails.env.production?
    http_basic_authenticate_with name: ENV["BASIC_AUTH_USERNAME"],
                                 password: ENV["BASIC_AUTH_PASSWORD"]
  end
end
