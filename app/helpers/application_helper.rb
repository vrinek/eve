module ApplicationHelper
  def ingame_link_to_item(item_type_id)
    link_to_function image_tag("info.png"), "CCPEVE.showInfo(#{item_type_id})", {:class => "ingame-item-info"} if is_igb?
  end
  
  def is_trusted?
    request.env["HTTP_EVE_TRUSTED"] == "Yes"
  end
  
  def is_igb?
    request.env["HTTP_USER_AGENT"] =~ /EVE\-IGB/
  end
  
  def nav_link(html, url)
    link_to_unless_current(html, url) do
      raw "<span class='current'>#{html}</span>"
    end
  end
  
  def request_trust
    if is_igb? and !is_trusted?
      "onload=\"CCPEVE.requestTrust('http://eve-box.com')\""
    end
  end
end
