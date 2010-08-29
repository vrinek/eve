class EveImport
  attr_reader :imported
  
  DATA_FOLDER = File.join(RAILS_ROOT, "tmp/dump_data")
  VERSION = 'tyr101'
  
  def initialize(model)
    # we need the model to find the constants ???
    @model = model
  end
  
  def get_xml
    # local_combo XML contains multiple tables (usually small ones)
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
    # TODO: migrate to Hpricot, I don't trust Nokogiri...
    @xml = Nokogiri::XML File.open(local, 'r').read
  end
  
  def total
    (@xml.root/"#{@model::EVE_TABLE_NAME}/row").size
  end
  
  def save
    # rows that fail due to referencing other rows will be retried later on
    to_retry = {}
    
    (@xml.root/"#{@model::EVE_TABLE_NAME}/row").each do |row|
      inst = @model.new
      
      # we should have a unique id-like field in the original table
      if @model::EVE_ID_FIELD
        id = (row%"#{@model::EVE_ID_FIELD}").content.to_i
        inst.id = id
      end
      atts = @model.translate(row)

      begin
        inst.attributes = atts
        inst.save
      rescue
        to_retry[id] = atts if @model::EVE_ID_FIELD
      end
    end
    
    unless to_retry.empty?
      # need to retry when records depend on one another (like a tree)
      fails = 0
      puts "\tRetrying for #{to_retry.size} failed..."
      keys = to_retry.keys.sort
      
      # until we are done or every one fails
      until keys.empty? or fails > keys.size do
        id = keys.shift

        inst = @model.new
        inst.id = id

        begin
          inst.attributes = to_retry[id]
          inst.save

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
