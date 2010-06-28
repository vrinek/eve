class CreateContracts < ActiveRecord::Migration
  def self.up
    create_table :contracts do |t|
      t.string :key
      t.text :data

      t.timestamps
    end
    
    add_index :contracts, :key
  end

  def self.down
    drop_table :contracts
  end
end