desc "Imports an EVE SQL dump table to the database"
task :import, :model, :needs => :environment do |t, args|
  model = args[:model].constantize
  
  ei = EveImport.new(model)
  ei.get_xml
  ei.save
end

