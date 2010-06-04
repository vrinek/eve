class ItemTypeMaterial < ActiveRecord::Base
  EVE_TABLE_NAME = "invTypeMaterials"
  EVE_ID_FIELD = false
  
  belongs_to :item_type
  belongs_to :material_type, :class_name => "ItemType", :foreign_key => "material_type_id"
  
  class << self
    def translate(row)
      @row = row

      return {
        :item_type_id     => field("typeID"),
        :material_type_id => field("materialTypeID"),
        :quantity         => field("quantity")
      }
    end

    def field(name)
      (@row%name).content
    end
  end
end
