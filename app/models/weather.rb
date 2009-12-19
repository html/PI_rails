class Weather < ActiveRecord::Base
  validates_uniqueness_of :date

  @@conditions = {
    "Mostly Cloudy" => 1,
    "Partly Cloudy" => 2,
    "Rain and Snow" => 3,
    "Scattered Showers" => 4,
    "Showers" => 5
  }

  @@images = {
    1 => 'mostly_cloudy',
    2 => 'partly_cloudy',
    3 => 'rain_snow',
    4 => 'chance_of_rain',
    5 => 'rain'
  }

  @@directions = {
    "N" => 0,
    "S" => 1,
    "W" => 2,
    "E" => 3
  }

  @@directions_translate = {
    0 => 'північний',
    1 => 'південний',
    2 => 'західний',
    3 => 'східний'
  }

  set_table_name :weather

  def self.get_weather
    if weather_is_not_up_to_date
      update_weather
    end

    weather
  end

  def self.weather_is_not_up_to_date
    d = maximum('date')
    !d || d < (Date.today + 3.days)
  end

  def self.update_weather
    @weather = Barometer.new('24700').measure
    today = Date.today

    @weather.forecast.each do |item|
      if item.date != today
        save_weather_row(item.date, item)
      end
    end

    save_weather_row(today,  @weather.current)
  end

  def self.weather
    all(:limit => 5, :order => 'date DESC')
  end

  def self.save_weather_row(date, item)
    row = find_or_initialize_by_date(date.to_s)
    row.humidity = item.humidity if item.humidity
    row.conditions = @@conditions[item.condition] if item.condition

    logger.info("Missing condition \"#{item.condition}\"") if item.condition && !@@conditions[item.condition]

    row.temperature = f_to_c item.temperature.fahrenheit if item.temperature
    row.wind_direction = @@directions[item.wind.direction] if item.wind

    logger.info("Missing direction \"#{item.condition}\"") if item.wind && !@@directions[item.wind.direction]

    row.wind_speed = m_to_k item.wind.miles if item.wind
    row.low_temperature = f_to_c item.low.fahrenheit if item.low
    row.high_temperature = f_to_c item.high.fahrenheit if item.low
    row.save
  end


  #Fahrenheit to Celcius conversion
  def self.f_to_c(tf)
    (tf-32) * 5 / 9
  end

  #Miles to kilometers conversion
  def self.m_to_k(m)
    m * 1.609344
  end

  def get_temperature
    temperature || (low_temperature && high_temperature ? sprintf("%s C | %s C", low_temperature, high_temperature) : 'невідома температура')
  end

  def get_date
    case date
      when Date.today then 'сьогодні'
      when Date.tomorrow then 'завтра'
      when Date.yesterday then 'вчора'
      else ''
    end + ', ' + date.to_s
  end

  def has_wind?
    wind_direction && wind_speed
  end

  def get_wind
    sprintf("%s, %s м/с", @@directions_translate[wind_direction], wind_speed)
  end

  def get_image_src
    sprintf('/images/weather/%s.png', @@images[conditions])
  end
end
