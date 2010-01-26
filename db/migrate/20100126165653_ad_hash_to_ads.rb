class AdHashToAds < ActiveRecord::Migration
  def self.up
    add_column :ads, :h, :string
  end

  def self.down
    remove_column :ads, :h
  end
end
