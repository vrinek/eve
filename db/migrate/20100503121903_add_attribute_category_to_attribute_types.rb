class AddAttributeCategoryToAttributeTypes < ActiveRecord::Migration
  def self.up
    add_column :attribute_types, :attribute_category_id, :integer
    add_index :attribute_types, :attribute_category_id
  end

  def self.down
    remove_index :attribute_types, :attribute_category_id
    remove_column :attribute_types, :attribute_category_id
  end
end