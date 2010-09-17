class OreHarvest
  attr :harvest
  attr :surplus
  attr :item_composition
  
  def initialize(item_composition, quantity = 1)
    @item_composition = normalized_composition(item_composition, quantity)
    @item_composition.each do |k, v|
      puts "#{pretty_s(v).rjust(9)} : #{k.name}"
    end
  end
  
  def find_most_efficient(strategy = :fill)
    reset
    @strategy = strategy
    composition = mineral_composition
    
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
  
  private
  
  def mineral_composition
    composition = @item_composition.dup
    composition.delete_if do |k, v|
      !MineralComposition.minerals.include?(k)
    end
    composition
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
      unless @surplus[mineral] == 0 or @surplus[mineral].blank?
        hash[mineral.name] = @surplus[mineral].to_f/@item_composition[mineral]
      end
      hash
    end
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
  
  def normalized_composition(item_composition, quantity)
    item_composition.inject(Hash.new) do |hash, kv|
      k, v = kv
      
      if k.composition.empty?
        hash[k] ||= 0
        hash[k] += v * quantity
      else
        normalized_composition(k.composition, v/k.portion_size).each do |k2, v2|
          hash[k2] ||= 0
          hash[k2] += v2
        end
      end
      hash
    end
  end
  
  def pretty_s(int)
    si = {
      3 => 'k',
      6 => 'mil',
      9 => 'bil'
    }

    if (size = int.to_s.size) > 3
      shown = size/3*3
      important = int / (10**(shown - 2))
      "#{important/100.0}#{si[shown]}"
    else
      int.to_s
    end
  end
end
