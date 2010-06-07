require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_belong_to :owner
  should_have_one :point
end
