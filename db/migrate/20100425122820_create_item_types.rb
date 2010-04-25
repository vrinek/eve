class CreateItemTypes < ActiveRecord::Migration
  def self.up
    create_table :item_types do |t|
      t.string :name
      t.float :volume
      t.integer :portion_size
      t.integer :market_group_id

      t.index [:name, :market_group_id]

      t.timestamps
    end
    
    
  end

  def self.down
    drop_table :item_types
  end
end
