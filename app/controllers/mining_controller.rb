class MiningController < ApplicationController
  before_filter :fetch_minerals
    
  def ore_value
    @title = "Ore Value Calculator"
    @description = "A calculator tool that helps you find out which ore is best to mine for optimal profit in the EVE Online MMORPG"
    @icon = "32_02"
    
    @basic_ores = ItemCategory.basic_ores
    
    initial_prices = {
      "Tritanium" => 2.0,
      "Pyerite" => 4.0,
      "Mexallon" => 22.0,
      "Isogen" => 64.0,
      "Nocxium" => 94.0,
      "Zydrine" => 2350.0,
      "Megacyte" => 4000.0,
      "Morphite" => 14300.0
    }
    
    if params[:key].blank?
      @prices = initial_prices
    else
      @prices = MineralValueSet.find_by_key(params[:key]).restore
    end
    
    puts @prices.inspect
  end

  def save
    @mineral_value_set = MineralValueSet.new_from(params[:minerals_json])
    
    unless @mineral_value_set.save
      @mineral_value_set = nil
      puts "validation failed"
    end
  rescue => e
    @mineral_value_set = nil
    puts "ERROR encountered: #{e}"
  end
  
  private
  
  def fetch_minerals
    @minerals = MineralValueSet.minerals
  end
end
