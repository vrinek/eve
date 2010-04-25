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
      FileUtils.makedirs(DATA_FOLDER)

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
    to_retry = {}
    
    (@xml.root/"table_data/row").each do |row|
      unless @model.exists?(id = (row%"field[@name='#{@model::EVE_ID_FIELD}']").content.to_i)
        obj = @model.new
        obj.id = id

        begin
          atts = @model.translate(row)
          obj.attributes = atts
          obj.save
        rescue
          to_retry[id] = atts
        end
      end
    end
    
    unless to_retry.empty?
      fails = 0
      puts "Retrying for #{to_retry.size} failed"
      keys = to_retry.keys

      until keys.empty? or fails == keys.size do
        id = keys.pop

        obj = @model.new
        obj.id = id

        begin
          obj.attributes = to_retry[id]
          obj.save

          fails = 0
        rescue
          fails += 1
          keys << id
        end
      end
    end
  end
end
