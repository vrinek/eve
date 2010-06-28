class ItemCategory < ActiveRecord::Base
  EVE_TABLE_NAME = "invCategories"
  EVE_ID_FIELD = "categoryID"
  
  has_many :item_groups

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
    
    def basic_ores
      return @basic_ores if @basic_ores
      
      ores = find(25).item_groups.collect{ |g|
        g.item_types.select{ |i|
          i.name == g.name
        }
      }
      ores = ores.flatten.sort_by(&:name).reverse

      @basic_ores = ores.inject({}) do |hash, ore|
        hash[ore] = ore.composition
        hash
      end
      
      @basic_ores
    end
  end
end
