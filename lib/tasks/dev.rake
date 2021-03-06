namespace :eve do
  desc "Finds ore requirements for an item"
  task :ore, :name, :quantity, :needs => :environment do |t, args|
    it = ItemType.find_by_name(args[:name])
    we_have = { # WELIT corp hangar (industry) in Thunderstone
      # :tritanium => 980000,
      # :pyerite => 68700,
      # :mexallon => 18220,
      # :noxcium => 88870,
      # :zydrine => 65470,
      # :megacyte => 66890
    }
    
    if it
      results = []
      if it.composition.empty?
        comp = {it => (args[:quantity] ? args[:quantity].to_i : 1)}
        oh = OreHarvest.new(comp, 1, we_have)
      else
        oh = OreHarvest.new(it.composition, (args[:quantity] ? args[:quantity].to_i : 1), we_have)
      end

      oh.find_most_efficient(:step)
      results << oh.display_results
      
      oh.find_most_efficient(:fill)
      results << oh.display_results
      
      puts side_by_side(results)
    else
      puts "No item found with name #{args[:name].inspect}"
    end
  end
end

def side_by_side(messages)
  msgs = messages.collect do |message|
    {:msg => message}
  end

  max_lines = msgs.map{|h| h[:msg].split("\n").size}.max

  msgs.each do |h|
    h[:width] = h[:msg].split("\n").map(&:size).max
    h[:lines] = h[:msg].split("\n").collect do |line|
      line.ljust(h[:width] + 5) + "\t\t"
    end
    if h[:lines].size < max_lines
      h[:lines] += [" " * (h[:width] + 5) + "\t\t"]*(max_lines - h[:lines].size)
    end
  end

  all_lines = msgs.collect{|h| h[:lines]}
  return all_lines.transpose.map(&:join).join("\n")
end
