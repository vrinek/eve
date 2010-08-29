class MineralValueSetsController < ApplicationController
  before_filter :fetch_minerals
    
  def index
    @title = "Ore Value Calculator"
    @description = "A calculator tool that helps you find out which ore is best to mine for optimal profit in the EVE Online MMORPG"
    @icon = "32_02"
    
    @basic_ores = ItemCategory.basic_ores
    
    initial_prices = {
      "Tritanium" => 2.3,
      "Pyerite" => 4.0,
      "Mexallon" => 33.0,
      "Isogen" => 60.0,
      "Nocxium" => 125.0,
      "Zydrine" => 1200.0,
      "Megacyte" => 2300.0,
      "Morphite" => 4900.0
    }
    
    if params[:key].blank?
      @prices = initial_prices
    else
      @mineral_value_set = MineralValueSet.find_by_key(params[:key])
      @prices = @mineral_value_set.restore
    end
  end

  def create
    @mineral_value_set = MineralValueSet.new_from(params[:minerals_json])
    
    unless @mineral_value_set.save
      @mineral_value_set = nil
    end
  rescue => e
    @mineral_value_set = nil
  end
  
  private
  
  def fetch_minerals
    @minerals = MineralValueSet.minerals
  end
end
