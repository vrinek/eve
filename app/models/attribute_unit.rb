class AttributeUnit < ActiveRecord::Base
  EVE_TABLE_NAME = "eveUnits"
  EVE_ID_FIELD = "unitID"
  
  has_many :attribute_types
  
  class << self
    def translate(row)
      @row = row

      return {
        :name    => field("unitName"),
        :display => field("displayName")
      }
    end

    def field(name)
      (@row%name).content
    end
  end
end
