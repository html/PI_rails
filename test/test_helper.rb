ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'shoulda'
require 'rr'
require 'blueprints'
require 'firewatir'

#XXX monkey patch to avoid firefox error
JsshSocket.module_eval do
  def js_eval(str)
    str.gsub!("\n", "")
    jssh_socket.send("#{str};\n", 0)
    value = read_socket()
    if false && md = /^(\w+)Error:(.*)$/.match(value)
      errclassname="JS#{md[1]}Error"
      unless JsshSocket.const_defined?(errclassname)
        JsshSocket.const_set(errclassname, Class.new(StandardError))
      end
      raise JsshSocket.const_get(errclassname), md[2]
    end
    value
  end
end

class ActiveSupport::TestCase
  include RR::Adapters::TestUnit
  VALID_IMAGE_PATH = File.expand_path(File.dirname(__FILE__) + '/fixtures/correct_image.png')

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

  def assert_contains_vk_login_widget
    assert_select '#vk_api_transport'
  end

  def assert_does_not_contain_vk_login_widget
    assert_select '#vk_api_transport', :count => 0
  end

  def assert_javascript_loaded(js)
    str =  "/javascripts/#{js}.js"
    assert_select 'script[type=text/javascript][src^=?]', str, 1
  end

  def assert_jquery_loaded
    assert_javascript_loaded 'jquery.min'
  end

  def assert_jquery_modal_loaded
    assert_jquery_loaded

    assert_javascript_loaded 'jquery/jqModal'
    assert_css_loaded '/stylesheets/jqModal'
  end

  def assert_css_loaded(css)
    assert_select 'link[type=text/css][href^=?]', css, 1
  end

  def assert_map_coord_choice_loaded
    assert_jquery_modal_loaded
    assert_javascript_loaded 'map_coord_choice'
  end

  def browser
    @@browser ||= Watir::Browser::new
  end

  def self.watir_test(&block)
    if watir_enabled
      yield
    end
  end

  def self.watir_enabled
    false
  end
end
