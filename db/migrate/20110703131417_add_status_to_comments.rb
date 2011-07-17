class AddStatusToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :status, :string, :default => '', :null => false
  end

  def self.down
    remove_column  :comments, :status
  end
end
