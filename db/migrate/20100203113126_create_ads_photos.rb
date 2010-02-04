class CreateAdsPhotos < ActiveRecord::Migration
  def self.up
    create_table :ads_photos, :id => false do |t|
      t.integer :ad_id
      t.integer :photo_id
    end
  end

  def self.down
    drop_table :ads_photos
  end
end
