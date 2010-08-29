class CreateAttributeUnits < ActiveRecord::Migration
  def self.up
    create_table :attribute_units do |t|
      t.string :name
      t.string :display
    end
  end

  def self.down
    drop_table :attribute_units
  end
end
