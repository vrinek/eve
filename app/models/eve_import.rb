class EveImport
  attr_reader :imported
  
  DATA_FOLDER = File.join(RAILS_ROOT, "tmp/dump_data")
  
  def initialize(model)
    @model = model
  end
  
  def get_xml
    name = "dom111-#{@model::EVE_TABLE_NAME}-mysql5-v1.xml"
    local = File.join(DATA_FOLDER, name)

    unless File.exists?(local)
      Net::HTTP.start("eve.no-ip.de") { |http|
        resp = http.get("/dom111/dom111-mysql5-xml-v1/#{name}.bz2")
        open(local+".bz2", "wb") { |file|
          file.write(resp.body)
        }
      }

      system "bunzip2 #{local}.bz2"
    end
    
    @xml = Nokogiri::XML open(local).read
  end
  
  def save
    (@xml.root/"table_data/row").each do |row|
      obj = @model.new
      obj.id = (row%"field[@name='#{@model::EVE_ID_FIELD}']").content.to_i
      
      obj.attributes = @model.translate(row)
      
      obj.save
    end
  end
end
