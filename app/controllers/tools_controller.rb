class ToolsController < ApplicationController
  before_filter :parse_shown_ids, :only => %w{fetch_children add_or_remove}
  
  def compare_items
    @title = "Item Comparison Tool"
    
    @roots = MarketGroup.all(:conditions => {:ancestry => nil}, :order => "name ASC")
    @depth = 0
  end
  
  def fetch_children
    @group = MarketGroup.find(params[:id])
    
    if @group.has_children?
      @children = @group.children.all(:order => "name ASC")
    else
      @children = @group.item_types.all(:order => "name ASC", :select => "name, id")
    end
    
    @depth = params[:depth].to_i + 1
  end
  
  def add_or_remove
    @items = ItemType.find(@shown_ids, :include => {:item_attributes => {:attribute_type => :attribute_unit}})
    
    @all_attribute_types = @items.collect do |item|
      item.item_attributes.collect do |attribute|
        attribute.attribute_type
      end
    end
    
    @all_attribute_types = @all_attribute_types.flatten.uniq.sort_by(&:code)
  end
  
  private
  
  def parse_shown_ids
    @shown_ids = params[:shown_ids].blank? ? [] : params[:shown_ids].split(",").uniq.map(&:to_i)
  end
end
