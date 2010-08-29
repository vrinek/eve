class OreHarvest
  attr :harvest
  attr :surplus
  
  def initialize(item_composition)
    @item_composition = item_composition
  end
  
  def reset
    @harvest = MineralComposition.basic_ores.inject(Hash.new) do |hash, ore|
      hash[ore] = 0
      hash
    end
    
    @surplus = MineralComposition.minerals.inject(Hash.new) do |hash, mineral|
      hash[mineral] = 0
      hash
    end
  end
  
  def compact_harvest
    @harvest.inject(Hash.new) do |hash, kv|
      ore, quantity = kv
      hash[ore.name] = quantity unless quantity == 0
      hash
    end
  end
  
  def compact_surplus
    @surplus.inject(Hash.new) do |hash, kv|
      mineral, quantity = kv
      hash[mineral.name] = quantity unless quantity == 0
      hash
    end
  end
  
  def total_volume
    @harvest.inject(0) do |total, kv|
      ore, quantity = kv
      total + quantity * ore.volume
    end
  end
  
  def surplus_percentage
    @item_composition.keys.inject(Hash.new) do |hash, mineral|
      unless @surplus[mineral] == 0
        hash[mineral.name] = @surplus[mineral].to_f/@item_composition[mineral]
      end
      hash
    end
  end
  
  def find_most_efficient(strategy = :fill)
    reset
    @strategy = strategy
    composition = @item_composition.dup
    
    until composition.values.sum == 0
      @mc = MineralComposition.new(composition, strategy)
      
      ore = @mc.best_ore_by_progress
      units = consume(ore)
      
      @mc.common_minerals(ore).each do |mineral|
        minerals_refined = MineralComposition.minerals_in_ore_units(mineral, ore, units)
        if minerals_refined >= composition[mineral]
          @surplus[mineral] = minerals_refined - composition[mineral] + @surplus[mineral]
          composition.delete mineral
        else
          composition[mineral] -= minerals_refined
        end
      end
    end
  end
  
  def display_results
    msg = ""
    msg += "\n" + "="*20 + "\n"
    msg += "STRATEGY: #{@strategy}"
    msg += "\nHARVEST:\n   TOTAL: #{total_volume.to_i}m3\n\n"
    compact_harvest.sort.each do |ore, quantity|
      msg += quantity.to_s.rjust(8) + "  #{ore}" + "\n"
    end
    
    msg += "\nSURPLUS:" + "\n"
    surplus_percentage.sort.each do |mineral, percent|
      msg += compact_surplus[mineral].to_s.rjust(6) + "\t" + "%.2f%%"%percent + "\t" + mineral + "\n"
    end
    
    return msg
  end
  
  def consume(ore)
    case @strategy
    when :fill
      units = @mc.minimum_units_needed_to_satisfy_one_mineral_need(ore)
    when :step
      units = ore.portion_size
    end
    
    @harvest[ore] += units
    return units
  end
end
