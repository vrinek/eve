class MarketGroup < ActiveRecord::Base
  EVE_TABLE_NAME = "invMarketGroups"
  EVE_ID_FIELD = "marketGroupID"
  
  has_ancestry
  has_many :item_types
  
  class << self
    def translate(row)
      @row = row
      pid = field("parentGroupID")

      return {
        :name      => field("marketGroupName"),
        :parent_id => (pid.empty? ? nil : pid.to_i)
      }
    end

    def field(name)
      (@row%name).content
    end
  end
end
