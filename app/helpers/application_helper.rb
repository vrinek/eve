module ApplicationHelper
  def ingame_link_to_item(item_type_id)
    if is_igb? or RAILS_ENV[/development/]
      item_type_id = item_type_id.id if item_type_id.is_a?(ItemType)
      link_to_function image_tag("info.png"), "CCPEVE.showInfo(#{item_type_id})", {:class => "ingame-item-info"}
    end
  end
  
  def is_trusted?
    request.env["HTTP_EVE_TRUSTED"] == "Yes"
  end
  
  def is_igb?
    request.env["HTTP_USER_AGENT"] =~ /EVE\-IGB/
  end
  
  def nav_link(html, url)
    unless controller.controller_name == url[:controller] and controller.action_name == url[:action]
      link_to(html, url)
    else
      raw "<span class='current'>#{html}</span>"
    end
  end
  
  def request_trust
    if is_igb? and !is_trusted?
      "CCPEVE.requestTrust('http://eve-box.com')"
    end
  end
  
  def graphic_tag_for(item, size = 16)
    if item.is_a?(ItemType)
      if item.graphic
        url = item.graphic.url(size)
      elsif item.item_group.item_category.name =~ /^(drone|ship)$/i
        url = Graphic.alt_url(item.id, size)
      end
      
      title = item.name
    end
    
    image_tag(url, :class => "icon", :size => "#{size}x#{size}", :title => title) if url
  end
end
