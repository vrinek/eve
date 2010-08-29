class CreateAttributeCategories < ActiveRecord::Migration
  def self.up
    create_table :attribute_categories do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :attribute_categories
  end
end
