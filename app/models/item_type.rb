class ItemType < ActiveRecord::Base
  EVE_TABLE_NAME = "invTypes"
  EVE_ID_FIELD = "typeID"
  
  belongs_to :market_group
  
  class << self
    def translate(row)
      @row = row

      return {
        :name            => field("typeName"),
        :volume          => field("volume").to_f,
        :portion_size    => field("portionSize").to_i,
        :market_group_id => field("marketGroupID").to_i
      }
    end

    def field(name)
      (@row%"field[@name='#{name}']").content
    end
  end
end
