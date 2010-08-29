class AddCapacityToItemTypes < ActiveRecord::Migration
  def self.up
    add_column :item_types, :capacity, :float
  end

  def self.down
    remove_column :item_types, :capacity
  end
end