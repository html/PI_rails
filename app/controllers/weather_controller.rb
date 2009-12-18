class WeatherController < ApplicationController
  def index
    @weather = Weather.get_weather
  end
end
