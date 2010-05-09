class MiningController < ApplicationController
  before_filter :fetch_minerals
  
  def ore_value
    @title = "Ore Value Calculator"
    @description = "A calculator tool that helps you find out which ore is best to mine for optimal profit in the EVE Online MMORPG"
    @icon = "32_02"
    
    ores = ItemCategory.find(25).item_groups.collect{|g| g.item_types.select{|i| i.name == g.name}}.flatten.sort_by(&:name).reverse
    
    @basic_ores = ores.inject({}) do |hash, ore|
      hash[ore] = ore.composition
      
      hash
    end
    
    @prices = session[:mineral_prices]
    @prices ||= (cookies[:mineral_prices] ? eval(cookies[:mineral_prices]) : nil)
    @prices ||= {
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
  
  def save_prices
    prices = params.keys.select{|k| k[/^mineral\-/]}.inject({}) do |hash, key|
      id = @minerals.find{|m| m.name == key.split("-").last}.id
      hash[id] = params[key].to_i
      
      hash
    end
    
    cookies[:mineral_prices] = {
      :value => prices,
      :expires => 2.weeks.from_now
    }
    
    session[:mineral_prices] = prices
  end
  
  private
  
  def fetch_minerals
    @minerals = ItemGroup.find(18).item_types.reject{|m| m.name == "Chalcopyrite"}
  end
end
