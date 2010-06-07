require 'test_helper'

class AdTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  should_have_one :point

  context "#map_point" do
    context "getter" do
      should "return map point if it is there" do
        @ad = Ad.make :point => Point.make(:lat => 123.123, :lng => 321.321)

        assert_equal '123.123x321.321', @ad.map_point
      end

      should "return empty string if there is no point associated" do
        @ad = Ad.make

        assert_equal '', @ad.map_point
      end
    end

    context "setter" do
      should "create point for ad if there is any" do
        @ad = Ad.make


        @ad.map_point = '1x2'

        @ad.reload

        assert_not_nil @ad.point
        assert_equal 1, @ad.point.lat
        assert_equal 2, @ad.point.lng
      end

      should "update existing point if there is one" do
        @ad = Ad.make :point => Point.make

        assert_difference 'Point.count', 0 do
          @ad.map_point = '2x3'
        end
      end
    end
  end
end
