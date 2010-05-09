class Graphic < ActiveRecord::Base
  EVE_TABLE_NAME = "eveGraphics"
  EVE_ID_FIELD = "graphicID"
  URL_BASE = "http://eve-box.s3.amazonaws.com/images/"
  
  has_many :attribute_types
  
  def url(size = 16)
    Graphic.url(icon, ((max_size && size > max_size) ? max_size : size))
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
        if graphic.icon.blank?
          graphic.destroy
        else
          sizes.each do |size|
            if File.exists?(local_base + "icons/#{size}_#{size}/icon#{graphic.icon}.png")
              graphic.max_size = size
            else
              break
            end
          end
          
          if graphic.max_size
            graphic.save
          else
            graphic.destroy
          end
        end
      end
    end
    
    def url(icon, size)
      URL_BASE + "icons/#{size}_#{size}/icon#{icon}.png"
    end
  end
end
