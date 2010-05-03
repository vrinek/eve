class AddIdColumnToItemAttributes < ActiveRecord::Migration
  def self.up
    add_column :item_attributes, :id, :primary_key
  end

  def self.down
    remove_column :item_attributes, :id
  end
end