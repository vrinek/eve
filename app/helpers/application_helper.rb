module ApplicationHelper
  def ingame_link_to_item(item_type_id)
    link_to_function image_tag("info.png"), "CCPEVE.showInfo(#{item_type_id})", {:class => "ingame-item-info"}
  end
  
  def is_trusted?
    false
  end
end
