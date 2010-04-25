class RenameUnitIdOfAttributeTypeToAttributeUnitId < ActiveRecord::Migration
  def self.up
    rename_column :attribute_types, :unit_id, :attribute_unit_id
  end

  def self.down
    rename_column :attribute_types, :attribute_unit_id, :unit_id
  end
end
