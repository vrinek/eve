class CreateItemTypes < ActiveRecord::Migration
  def self.up
    create_table :item_types do |t|
      t.string :name
      t.float :volume
      t.integer :portion_size
    
      t.integer :market_group_id
      t.integer :graphic_id
      t.integer :item_group_id
    end
    
    add_index :item_types, :market_group_id
    add_index :item_types, :graphic_id
    add_index :item_types, :item_group_id
  end

  def self.down
    drop_table :item_types
  end
end