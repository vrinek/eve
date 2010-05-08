class AddGraphicIdAndItemGroupIdColumnsToItemType < ActiveRecord::Migration
  def self.up
    add_column :item_types, :graphic_id, :integer
    add_column :item_types, :item_group_id, :integer
    
    add_index :item_types, :graphic_id
    add_index :item_types, :item_group_id
  end

  def self.down
    remove_index :item_types, :item_group_id
    remove_index :item_types, :graphic_id
    
    remove_column :item_types, :item_group_id
    remove_column :item_types, :graphic_id
  end
end