class CreateAttributeTypes < ActiveRecord::Migration
  def self.up
    create_table :attribute_types do |t|
      t.string :code
      t.string :name
      t.boolean :high_is_good
      
      t.integer :attribute_unit_id
      t.integer :attribute_category_id
      t.integer :graphic_id
    end
    
    add_index :attribute_types, :attribute_unit_id
    add_index :attribute_types, :attribute_category_id
    add_index :attribute_types, :graphic_id
  end

  def self.down
    drop_table :attribute_types
  end
end