# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ::Actions
  @@local_domain = 'http://pi'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :assign_host

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  def assign_host
    @clean_host = request.env['SERVER_NAME'] == '127.0.0.1' ? '127.0.0.1' : request.env['SERVER_NAME'].sub(/^\w+\./, '')
    @host = request.env['SERVER_NAME'] == '127.0.0.1' ? @@local_domain : 'http://' +  @clean_host
  end
end
