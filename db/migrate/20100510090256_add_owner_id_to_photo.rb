class AddOwnerIdToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :owner_id, :integer
    Photo.update_all :owner_id => 0
  end

  def self.down
    remove_column :photos, :owner_id
  end
end
