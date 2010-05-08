class CreateGraphics < ActiveRecord::Migration
  def self.up
    create_table :graphics do |t|
      t.string :icon
      t.string :description
      t.integer :max_size

      t.timestamps
    end
  end

  def self.down
    drop_table :eve_graphics
  end
end
