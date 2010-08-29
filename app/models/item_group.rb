class ItemGroup < ActiveRecord::Base
  EVE_TABLE_NAME = "invGroups"
  EVE_ID_FIELD = "groupID"
  
  has_many :item_types
  belongs_to :item_category
  belongs_to :graphic
  
  class << self
    def translate(row)
      @row = row

      return {
        :name             => field("groupName"),
        :item_category_id => field("categoryID"),
        :graphic_id       => field("graphicID")
      }
    end

    def field(name)
      (@row%name).content
    end
  end
end
