class CreateMarketGroups < ActiveRecord::Migration
  def self.up
    create_table :market_groups do |t|
      t.string :ancestry
      t.string :name

      t.timestamps
    end
    
    add_index :market_groups, :ancestry
  end

  def self.down
    drop_table :market_groups
  end
end
