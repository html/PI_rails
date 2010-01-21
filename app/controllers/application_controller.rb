# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'create_json'
require 'phpbb_extension'

class ApplicationController < ActionController::Base
  include PhpbbAuth
  include ::Actions

  rescue_from 'Acl9::AccessDenied', :with => :access_denied
  rescue_from 'ActiveRecord::RecordNotFound', :with => :not_found
  rescue_from 'ActionController::RoutingError', :with => :not_found

  helper_method :current_user
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :assign_host
  before_filter :set_current_user
  before_filter :assign_poll

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
  def assign_host
    @host = 'http://' +  APPLICATION_HOST
  end

  def access_denied
    render :file => "#{RAILS_ROOT}/public/422.html", :status => 422 and return
  end

  def not_found
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404 and return
  end

  def set_current_user
    @current_user = current_user
  end
  
  def assign_poll
    if RAILS_ENV != 'test'
      @poll = PhpbbTopics.last_poll(cookies, @current_user)
    end
  end

  def assign_photo
    @photo = Photo.random
  end
end
