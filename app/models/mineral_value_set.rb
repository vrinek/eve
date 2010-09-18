class MineralValueSet < JsonStore
  set_table_name :mineral_value_sets
  
  def data_is_valid
    json = JSON.restore data
    json.is_a?(Hash) and (json.keys - (MineralValueSet.valid_keys)) == []
  end
  
  def json=(json)
    restored = JSON.restore(json)
    self.data = (MineralValueSet.valid_keys).inject({}){ |hash, key|
      hash[key] = restored[key].to_f
      hash
    }.to_json
  end
  
  def self.minerals
    return @minerals if @minerals

    @minerals = ItemGroup.find(18).item_types.reject{|m| m.name == "Chalcopyrite"}
  end
  
  def self.valid_keys
    MineralValueSet.minerals.map(&:name) + ['Refining Efficiency']
  end
end
