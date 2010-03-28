ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'shoulda'
require 'machinist/active_record'
require 'rr'

PhpbbUser.class_eval do
  establish_connection 'test'

  def user_id
    id
  end
end

Ad.blueprint do
  title 'test'
  content 'test'
  contacts 'test'
  tag_list 'asdf'
end

Article.blueprint do
  
end

PhpbbUser.blueprint do |b|
  b.group_id 1
end

class ActiveSupport::TestCase
  include RR::Adapters::TestUnit

  setup do
    Sham.reset(:before_each)
  end

  def login_as(user)
    #@request.session[:user_id] = session[:user_id] = user.id
  end

  def login_as_admin(user = nil)
    user = user || (@admin ||= PhpbbUser.create!)
    user.update_attributes! :group_id => 5
    stub(@controller).current_user { user }
    @request.cookies["#{PHPBB_AUTH_COOKIE_NAME}_sid"] = 'xx'
  end
end
