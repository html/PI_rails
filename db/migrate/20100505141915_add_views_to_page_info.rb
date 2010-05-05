class AddViewsToPageInfo < ActiveRecord::Migration
  def self.up
    add_column :pages_info, :views, :integer, :default => 0
  end

  def self.down
    remove_column :pages_info, :views
  end
end
