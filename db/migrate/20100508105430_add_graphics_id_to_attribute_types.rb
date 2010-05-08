class AddGraphicsIdToAttributeTypes < ActiveRecord::Migration
  def self.up
    add_column :attribute_types, :graphic_id, :integer
    add_index :attribute_types, :graphic_id
  end

  def self.down
    remove_index :attribute_types, :graphic_id
    remove_column :attribute_types, :graphic_id
  end
end