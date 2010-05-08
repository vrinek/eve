namespace :eve_dump do
  desc "Imports an EVE SQL dump table to the database"
  task :import, :model, :needs => :environment do |t, args|
    unless args[:model] == "all" or args[:model].blank?
      models = [args[:model].constantize]
    else
      models = [ItemType, MarketGroup, AttributeType, AttributeUnit, ItemAttribute, AttributeCategory]
    end
    
    models.each do |model|
      model.delete_all
      puts "Importing #{model}"
      
      ei = EveImport.new(model)
      ei.get_xml
      
      puts "\tdone\tETA"
      ticking = Thread.new do
        time = Time.now.to_f
        while true
          sleep 1
          
          dt = Time.now.to_f - time
          progress = model.count/ei.total.to_f
          eta = (dt/progress - dt).to_i
          
          puts ["--", "%.1f%%" % (progress * 100), "#{eta/60}:#{(eta%60).to_s.rjust(2, '0')}"] * "\t"
        end
      end
      ei.save
      
      ticking.kill

      ei.fix

      puts "Added #{model.count} #{model} successfully"
    end
  end
end
