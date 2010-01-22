class CreatePagesInfo < ActiveRecord::Migration
  def self.up
    create_table :pages_info do |t|
      t.string :page_id
      t.text :keywords
      t.text :description
      t.integer :inherits_keywords_from
      t.integer :inherits_description_from
      t.integer :item_id
      t.string :item_type

      t.timestamps
    end
  end

  def self.down
    drop_table :pages_info
  end
end
