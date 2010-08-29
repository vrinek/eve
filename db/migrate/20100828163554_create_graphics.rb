class CreateGraphics < ActiveRecord::Migration
  def self.up
    create_table :graphics do |t|
      t.string :icon
      t.string :description
      t.integer :max_size
    end
  end

  def self.down
    drop_table :graphics
  end
end
