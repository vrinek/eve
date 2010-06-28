class ItemCategory < ActiveRecord::Base
  EVE_TABLE_NAME = "invCategories"
  EVE_ID_FIELD = "categoryID"
  
  has_many :item_groups

  ores = self.find(25).item_groups.collect{ |g|
    g.item_types.select{ |i|
      i.name == g.name
    }
  }
  ores = ores.flatten.sort_by(&:name).reverse
  
  BASIC_ORES = ores.inject({}) do |hash, ore|
    hash[ore] = ore.composition
    hash
  end
  
  class << self
    def translate(row)
      @row = row

      return {
        :name       => field("categoryName"),
        :graphic_id => field("graphicID")
      }
    end

    def field(name)
      (@row%name).content
    end
  end
end
