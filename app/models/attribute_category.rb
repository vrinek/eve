class AttributeCategory < ActiveRecord::Base
  EVE_TABLE_NAME = "dgmAttributeCategories"
  EVE_ID_FIELD = "categoryID"
  NULL_CAT_ID = 9
  
  has_many :attribute_types

  class << self
    def translate(row)
      @row = row

      return {
        :name => field("categoryName")
      }
    end

    def field(name)
      (@row%"field[@name='#{name}']").content
    end
  end
end
