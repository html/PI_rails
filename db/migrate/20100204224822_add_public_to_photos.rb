class AddPublicToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :public, :boolean
    Photo.update_all :public => true
  end

  def self.down
    remove_column :photos, :public
  end
end
