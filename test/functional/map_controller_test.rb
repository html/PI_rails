require 'test_helper'

class MapControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  should "load javascripts for maps" do
    get :index

    assert_javascript_loaded 'jquery/jquery.ba-bbq'
    assert_javascript_loaded 'jquery/jquery.scrollTo'

    assert_javascript_loaded 'egeoxml'
    assert_javascript_loaded 'lambda'
    assert_javascript_loaded 'egeoxml_ext'
    assert_javascript_loaded 'map'
    assert_javascript_loaded 'map_on_load'

    assert_jquery_loaded
  end
end
