class Graphic < ActiveRecord::Base
  EVE_TABLE_NAME = "eveGraphics"
  EVE_ID_FIELD = "graphicID"
  URL_BASE = "http://eve-box.s3.amazonaws.com/images/"
  
  has_many :attribute_types
  
  def url(size = 16, url_base = URL_BASE)
    size = max_size if max_size and size > max_size
    url_base + "icons/#{size}_#{size}/icon#{icon}.png"
  end
  
  class << self
    def translate(row)
      @row = row

      return {
        :icon        => field("icon"),
        :description => (field("urlWeb").blank? ? field("description") : field("urlWeb"))
      }
    end

    def field(name)
      (@row%"field[@name='#{name}']").content
    end
    
    def fix_after_import
      local_base = "#{`echo ~`.strip}/Downloads/Dominion_1.1_imgs/"
      sizes = [16, 32, 64, 128]
      
      find_each do |graphic|
        sizes.each do |size|
          if File.exists?(graphic.icon_url(size, local_base))
            graphic.max_size = size
          else
            break
          end
        end
        
        graphic.save
      end
    end
  end
end
