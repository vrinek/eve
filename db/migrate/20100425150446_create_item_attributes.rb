class CreateItemAttributes < ActiveRecord::Migration
  def self.up
    create_table :item_attributes, :id => false do |t|
      t.integer :item_type_id
      t.integer :attribute_type_id
      t.integer :integer_value
      t.float :float_value

      t.timestamps
    end
    
    add_index :item_attributes, [:item_type_id, :attribute_type_id]
  end

  def self.down
    drop_table :item_attributes
  end
end
