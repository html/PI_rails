ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'shoulda'
require 'rr'
require 'blueprints'

class ActiveSupport::TestCase
  include RR::Adapters::TestUnit

  setup do
    Sham.reset
  end

  def login(user = nil)
    @logged_user ||= PhpbbUser.create!
    stub(@controller).current_user { @logged_user }
    @request.cookies["#{PHPBB_AUTH_COOKIE_NAME}_sid"] = 'xx'
  end

  def login_as_admin(user = nil)
    user = user || (@admin ||= PhpbbUser.create!)
    user.update_attributes! :group_id => 5
    stub(@controller).current_user { user }
    @request.cookies["#{PHPBB_AUTH_COOKIE_NAME}_sid"] = 'xx'
  end

  def make_cookied_ad
    check_hash = Digest::MD5.hexdigest(rand.to_s)
    @request.cookies['ad_' + check_hash] = true
    Ad.make :h => check_hash
  end

  def assert_paginated(*args, &block)
    args = args.extract_options!
    args[:try_pages].times do |i|
      block.call(i + 1)
      assert_select args[:selector], args[:items_per_page]
    end
  end

  def assert_contains_n_times(str1, str2, num)
    assert_equal num,str1.scan(str2).size
  end

  def assert_response_contains(str, num)
    assert_contains_n_times @response.body, str, num
  end

  def assert_title_equals(value)
    assert_select 'h1', value
    assert_select 'head title', value
  end

  def assert_access_denied
    assert_response 422
  end

  def self.assert_access_denied(&block)
    should "be available only for some user" do
      block.call
      assert_access_denied 
    end
  end

  def assert_contains_right_block(&block)
    assert_select '.poll .top'
    assert_select '.poll .content', &block
    assert_select '.poll .bottom'
  end

  #copied and changed from assert_generates
  def assert_routes_equal(expected_path, options, defaults={}, extras = {}, message=nil)
    clean_backtrace do
      # Load routes.rb if it hasn't been loaded.
      ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?

      generated_path, extra_keys = ActionController::Routing::Routes.generate_extras(options, defaults)
      found_extras = options.reject {|k, v| ! extra_keys.include? k}

      msg = build_message(message, "found extras <?>, not <?>", found_extras, extras)
      assert_block(msg) { found_extras == extras }

      msg = build_message(message, "The generated path <?> did not match <?>", generated_path,
          expected_path)
      assert_block(msg) { expected_path == generated_path }
    end
  end

  def assert_not_found
    assert_response 404
  end
end
