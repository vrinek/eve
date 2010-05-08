class MiningController < ApplicationController
  def ore_value
    ores = ItemCategory.find(25).item_groups.collect{|g| g.item_types.select{|i| i.name == g.name}}.flatten.sort_by(&:name).reverse
    @minerals = ItemGroup.find(18).item_types.reject{|m| m.name == "Chalcopyrite"}
    
    @basic_ores = ores.inject({}) do |hash, ore|
      hash[ore] = ore.composition
      
      hash
    end
    
    @prices = {
      34 => 2,
      35 => 4,
      36 => 22,
      37 => 64,
      38 => 94,
      39 => 2350,
      40 => 4000,
      11399 => 14300
    }
  end
end
