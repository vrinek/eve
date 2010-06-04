class ItemType < ActiveRecord::Base
  EVE_TABLE_NAME = "invTypes"
  EVE_ID_FIELD = "typeID"
  
  belongs_to :market_group
  belongs_to :graphic
  belongs_to :item_group
  has_many :item_attributes
  has_many :item_type_materials
  
  def attribute(code)
    item_attributes.detect{|ia| ia.attribute_type.code == code}
  end
  
  def composition
    item_type_materials.inject({}) do |hash, mat|
      hash[mat.material_type] = mat.quantity
      
      hash
    end
  end
  
  class << self
    def translate(row)
      @row = row

      return {
        :name            => field("typeName"),
        :volume          => field("volume").to_f,
        :portion_size    => field("portionSize").to_i,
        :market_group_id => field("marketGroupID"),
        :graphic_id      => field("graphicID"),
        :item_group_id   => field("groupID")
      }
    end

    def field(name)
      (@row%name).content
    end
  end
end
