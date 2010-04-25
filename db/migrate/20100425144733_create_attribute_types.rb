class CreateAttributeTypes < ActiveRecord::Migration
  def self.up
    create_table :attribute_types do |t|
      t.string :code
      t.string :name
      t.boolean :high_is_good
      t.integer :unit_id

      t.timestamps
    end
    
    add_index :attribute_types, :unit_id
  end

  def self.down
    drop_table :attribute_types
  end
end
