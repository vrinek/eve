class MineralComposition
  BASIC_ORE_IDS = [18, 19, 20, 21, 22, 1223, 1224, 1225, 1226, 1227, 1228, 1229, 1230, 1231, 1232, 11396]
  MINERAL_IDS = [34, 35, 36, 37, 38, 39, 40, 11399]
  
  attr :composition

  def initialize(composition, strategy)
    @composition = composition
    @strategy = strategy
  end
  
  def ore_units_needed_for_mineral(mineral, ore)
    MineralComposition.ore_quantity_to_produce_mineral(mineral, ore, @composition[mineral])
  end
  
  def minimum_units_needed_to_satisfy_one_mineral_need(ore)
    needs = (common_minerals(ore)).collect do |mineral|
      ore_units_needed_for_mineral(mineral, ore)
    end
    
    needs.min
  end
  
  def minimum_volume_needed_to_satisfy_one_mineral_need(ore)
    minimum_units_needed_to_satisfy_one_mineral_need(ore) * ore.volume
  end
  
  def progress_by_consuming_ore(ore)
    case @strategy
    when :fill
      minimum = minimum_volume_needed_to_satisfy_one_mineral_need(ore)
    when :step
      minimum = 1
    end
    common_minerals(ore).inject(0.0) do |progress, mineral|
      progress + minimum / (ore_units_needed_for_mineral(mineral, ore) * ore.volume)
    end
  end
  
  def best_ore_by_progress
    all_progress = useful_ores.inject(Hash.new) do |hash, ore|
      hash[ore] = progress_by_consuming_ore(ore)
      hash
    end
    
    best = all_progress.max do |a, b|
      a[1] <=> b[1]
    end
    best[0]
  end
  
  def useful_ores
    MineralComposition.basic_ores.reject do |ore|
      common_minerals(ore).empty?
    end
  end
  
  def common_minerals(ore)
    @composition.keys & MineralComposition.basic_ore_compositions[ore].keys
  end
  
  class << self
    def ore_quantity_to_produce_mineral(mineral, ore, quantity)
      (quantity.to_f / ore.composition[mineral]).ceil * ore.portion_size
    end
    
    def minerals_in_ore_units(mineral, ore, units)
      basic_ore_compositions[ore][mineral] * (units / ore.portion_size).floor
    end
    
    def basic_ore_compositions
      return @basic_ore_compositions if @basic_ore_compositions
      
      @basic_ore_compositions = basic_ores.inject(Hash.new) do |hash, ore|
        hash[ore] = ore.composition
        hash
      end
    end
    
    def basic_ores
      return @basic_ores if @basic_ores
      @basic_ores = ItemType.all(:conditions => {:id => BASIC_ORE_IDS})
    end
    
    def minerals
      return @minerals if @minerals
      @minerals = ItemType.all(:conditions => {:id => MINERAL_IDS})
    end
  end
end
