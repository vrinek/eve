class CreateItemAttributes < ActiveRecord::Migration
  def self.up
    create_table :item_attributes do |t|
      t.integer :integer_value
      t.float :float_value

      t.integer :item_type_id
      t.integer :attribute_type_id
    end
    
    add_index :item_attributes, :item_type_id
    add_index :item_attributes, :attribute_type_id
  end

  def self.down
    drop_table :item_attributes
  end
end