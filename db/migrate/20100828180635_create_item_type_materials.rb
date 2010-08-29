class CreateItemTypeMaterials < ActiveRecord::Migration
  def self.up
    create_table :item_type_materials do |t|
      t.integer :item_type_id
      t.integer :material_type_id
      t.integer :quantity
    end
    
    add_index :item_type_materials, :item_type_id
    add_index :item_type_materials, :material_type_id
  end

  def self.down
    drop_table :item_type_materials
  end
end