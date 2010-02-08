class AddPublicToAds < ActiveRecord::Migration
  def self.up
    add_column :ads, :public, :boolean
    Ad.update_all :public => true
  end

  def self.down
    remove_column :ads, :public
  end
end
