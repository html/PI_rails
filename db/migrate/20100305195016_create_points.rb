class CreatePoints < ActiveRecord::Migration
  def self.up
    create_table :points do |t|
      t.float :lat
      t.float :lng
      t.integer :item_id
      t.string :item_type

      t.timestamps
    end
  end

  def self.down
    drop_table :points
  end
end
