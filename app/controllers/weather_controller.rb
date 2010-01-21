class WeatherController < ApplicationController
  before_filter :assign_photo, :only => [:index]
  def index
    @weather = Weather.get_weather
  end
end
