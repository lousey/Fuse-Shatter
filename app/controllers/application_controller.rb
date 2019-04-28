class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate
  protected
        def authenticate
            authenticate_or_request_with_http_basic do |user_name, password|
              user_name == "visitor" && password == "visit1010"
            end
        end
end
