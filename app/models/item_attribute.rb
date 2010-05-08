class ItemAttribute < ActiveRecord::Base
  EVE_TABLE_NAME = "dgmTypeAttributes"
  EVE_ID_FIELD = false
  POSTGRESQL_MAX_INT = 2147483647
  POSTGRESQL_MIN_INT = -2147483648
  
  belongs_to :item_type
  belongs_to :attribute_type
  
  def value(raw = false)
    v = (integer_value.nil? ? float_value : integer_value)
    
    unless raw
      case attribute_type.attribute_unit.try(:display)
      when "typeID"
        begin
          v = ItemType.find(v).name
        rescue
        end
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
      max_int = max_float = 0
      
      all(:select => :attribute_type_id, :group => :attribute_type_id).map(&:attribute_type_id).each do |id|
        ias = all(:conditions => {:attribute_type_id => id})
        values = ias.map do |ia|
          ia.value(true)
        end
        
        if values.max < POSTGRESQL_MAX_INT and values.min > POSTGRESQL_MIN_INT and values.map(&:to_i) == values # all should be integers
          puts "int\t" + values.uniq.inspect
          ias.each do |ia|
            unless ia.is_integer?
              pre_val = ia.value(true)
              ia.update_attributes :integer_value => ia.value(true).to_i, :float_value => nil
              raise "there was an error in value conversion" if ia.value(true) != pre_val
            end
          end
          
          max_int = values.max unless max_int > values.max
        else # all should be floats
          puts "flo\t" + values.uniq.inspect
          ias.each do |ia|
            unless ia.is_float?
              pre_val = ia.value(true)
              ia.update_attributes :integer_value => nil, :float_value => ia.value(true).to_f
              raise "there was an error in value conversion" if ia.value(true) != pre_val
            end
          end

          max_float = values.max unless max_float > values.max
        end
      end
      
      puts "MAX\n\tfloat = #{max_float}\n\tinteger = #{max_int}"
    end
  end
end
