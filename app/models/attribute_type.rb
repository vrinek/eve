class AttributeType < ActiveRecord::Base
  EVE_TABLE_NAME = "dgmAttributeTypes"
  EVE_ID_FIELD = "attributeID"
  
  belongs_to :attribute_unit
  belongs_to :attribute_category
  has_many :item_attributes
  
  class << self
    def translate(row)
      @row = row

      return {
        :name                  => field("displayName"),
        :code                  => field("attributeName"),
        :high_is_good          => (field("highIsGood").to_i == 1),
        :attribute_unit_id     => field("unitID").to_i,
        :attribute_category_id => field("categoryID").to_i
      }
    end

    def field(name)
      (@row%"field[@name='#{name}']").content
    end
  end
end
