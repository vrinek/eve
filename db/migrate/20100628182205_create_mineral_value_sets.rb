class CreateMineralValueSets < ActiveRecord::Migration
  def self.up
    create_table :mineral_value_sets do |t|
      t.string :key
      t.string :data

      t.timestamps
    end
    
    add_index :mineral_value_sets, :key
  end

  def self.down
    drop_table :mineral_value_sets
  end
end