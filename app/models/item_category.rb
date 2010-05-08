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
      (@row%"field[@name='#{name}']").content
    end
  end
end
