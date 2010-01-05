# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Authentication
  rescue_from 'Acl9::AccessDenied', :with => :access_denied
  rescue_from 'ActiveRecord::RecordNotFound', :with => :not_found
  rescue_from 'ActionController::RoutingError', :with => :not_found
  include Authentication
  include ::Actions
  @@local_domain = 'http://pi'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :assign_host

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
  def assign_host
    @clean_host = request.env['SERVER_NAME'] == '127.0.0.1' ? '127.0.0.1' : request.env['SERVER_NAME'].sub(/^\w+\./, '')
    @host = request.env['SERVER_NAME'] == '127.0.0.1' ? @@local_domain : 'http://' +  @clean_host
  end

  def access_denied
    render :file => "#{RAILS_ROOT}/public/422.html", :status => 422 and return
  end

  def not_found
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404 and return
  end
end
