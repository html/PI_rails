class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.boolean :public
      t.string :value
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
