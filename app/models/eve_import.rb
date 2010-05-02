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
      
      puts "\tDownloading..."
      
      domain = "eve.no-ip.de"
      rest_of_url = "/dom111/dom111-mysql5-xml-v1/#{name}.bz2"
      
      unless `which wget`.blank? # in other words, if we have wget installed
        system "wget http://#{domain}#{rest_of_url} -O #{local}.bz2"
      else
        Net::HTTP.start(domain) { |http|
          resp = http.get(rest_of_url)
          open(local+".bz2", "wb") { |file|
            file.write(resp.body)
          }
        }
      end

      system "bunzip2 #{local}.bz2"
    end
    
    @xml = Nokogiri::XML open(local).read
  end
  
  def total
    (@xml.root/"table_data/row").size
  end
  
  def save
    to_retry = {}
    
    (@xml.root/"table_data/row").each do |row|
      obj = @model.new
      
      if @model::EVE_ID_FIELD
        id = (row%"field[@name='#{@model::EVE_ID_FIELD}']").content.to_i
        obj.id = id
      end
      atts = @model.translate(row)

      begin
        obj.attributes = atts
        obj.save
      rescue
        to_retry[id] = atts if @model::EVE_ID_FIELD
      end
    end
    
    unless to_retry.empty?
      # need to retry when records depend on one another (like a tree)
      fails = 0
      puts "\tRetrying for #{to_retry.size} failed..."
      keys = to_retry.keys.sort

      until keys.empty? or fails > keys.size do
        id = keys.shift

        obj = @model.new
        obj.id = id

        begin
          obj.attributes = to_retry[id]
          obj.save

          fails = 0
        rescue
          fails += 1
          keys.push id
        end
      end
      
      if fails > 0
        puts "ERROR: could not save the following ids\n\t#{keys.inspect}"
      end
    end
  end
end
