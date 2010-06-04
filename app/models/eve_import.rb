class EveImport
  attr_reader :imported
  
  DATA_FOLDER = File.join(RAILS_ROOT, "tmp/dump_data")
  VERSION = 'tyr101'
  
  def initialize(model)
    @model = model
  end
  
  def get_xml
    local_combo = File.join(DATA_FOLDER, "#{VERSION}-#{@model::EVE_TABLE_NAME[0..2]}.xml")
    local_table = File.join(DATA_FOLDER, "#{VERSION}-#{@model::EVE_TABLE_NAME}.xml")

    if File.exists?(local_table)
      local = local_table
    elsif File.exists?(local_combo)
      local = local_combo
    else
      raise "Can't find the XML file"
    end
    
    puts "\tusing: #{local}"
    @xml = Nokogiri::XML open(local).read
  end
  
  def total
    (@xml.root/"#{@model::EVE_TABLE_NAME}/row").size
  end
  
  def save
    to_retry = {}
    
    (@xml.root/"#{@model::EVE_TABLE_NAME}/row").each do |row|
      obj = @model.new
      
      if @model::EVE_ID_FIELD
        id = (row%"#{@model::EVE_ID_FIELD}").content.to_i
        obj.id = id
      end
      atts = @model.translate(row)

      begin
        obj.attributes = atts
        obj.save
      rescue => e
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
  
  def fix
    if @model.respond_to?(:fix_after_import)
      puts "Fixing..."
      @model.fix_after_import
    end
  end
end
