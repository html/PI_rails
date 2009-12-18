class CreateWeather < ActiveRecord::Migration
  def self.up
    create_table :weather do |t|
      t.date :date
      t.string :humidity
      t.integer :conditions
      t.integer :temperature
      t.integer :low_temperature
      t.integer :high_temperature
      t.integer :wind_direction
      t.integer :wind_speed
      t.timestamps
    end
  end

  def self.down
    drop_table :weather
  end
end
