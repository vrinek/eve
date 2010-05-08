class CreateItemGroups < ActiveRecord::Migration
  def self.up
    create_table :item_groups do |t|
      t.integer :item_category_id
      t.string :name
      t.integer :graphic_id

      t.timestamps
    end
    
    add_index :item_groups, :item_category_id
    add_index :item_groups, :graphic_id
  end

  def self.down
    drop_table :item_groups
  end
end