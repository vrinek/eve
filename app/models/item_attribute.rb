class ItemAttribute < ActiveRecord::Base
  EVE_TABLE_NAME = "dgmTypeAttributes"
  EVE_ID_FIELD = false
  
  belongs_to :item_type
  belongs_to :attribute_type
  
  def value
    v = (integer_value.nil? ? float_value : integer_value)
    
    case attribute_type.attribute_unit.try(:display)
    when "typeID"
      begin
        v = ItemType.find(v).name
      rescue
      end
    end
    
    return v
  end
  
  def is_integer?
    !integer_value.blank?
  end
  
  def is_float?
    !float_value.blank?
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
    
    def fix_after_import
      all(:select => :attribute_type_id, :group => :attribute_type_id).map(&:attribute_type_id).each do |id|
        ias = all(:conditions => {:attribute_type_id => id})
        values = ias.map(&:value)
        
        if values.map(&:to_i) == values # all should be integers
          puts "int\t" + values.uniq.inspect
          ias.each do |ia|
            unless ia.is_integer?
              ia.update_attributes :integer_value => ia.value.to_i, :float_value => nil
            end
          end
        else # all should be floats
          puts "flo\t" + values.uniq.inspect
          ias.each do |ia|
            unless ia.is_float?
              ia.update_attributes :integer_value => nil, :float_value => ia.value.to_f
            end
          end
        end
      end
    end
  end
end
