class ItemAttribute < ActiveRecord::Base
  EVE_TABLE_NAME = "dgmTypeAttributes"
  EVE_ID_FIELD = false
  
  belongs_to :item_type
  belongs_to :attribute_type
  
  def value
    v = (integer_value.nil? ? float_value : integer_value)
    
    case attribute_type.attribute_unit.try(:name)
    when "typeID"
      v = ItemType.find(v).name
    end
    
    return v
  end
  
  def full_value
    value.to_s + attribute_type.attribute_unit.display.to_s
  end
  
  class << self
    def translate(row)
      @row = row

      return {
        :item_type_id      => field("typeID").to_i,
        :attribute_type_id => field("attributeID").to_i,
        :integer_value     => (field("valueInt").blank? ? nil : field("valueInt").to_i),
        :float_value       => (field("valueFloat").blank? ? nil : field("valueFloat").to_f)
      }
    end

    def field(name)
      (@row%"field[@name='#{name}']").content
    end
  end
end
