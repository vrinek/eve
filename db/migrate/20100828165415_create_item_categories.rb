class CreateItemCategories < ActiveRecord::Migration
  def self.up
    create_table :item_categories do |t|
      t.string :name
      t.integer :graphic_id
    end
    
    add_index :item_categories, :graphic_id
  end

  def self.down
    drop_table :item_categories
  end
end