class ToolsController < ApplicationController
  def compare_items
    @roots = MarketGroup.all(:conditions => {:ancestry => nil}, :order => "name ASC")
  end
  
  def fetch_children
    mg = MarketGroup.find(params[:id])
    
    if mg.has_children?
      @children = mg.children.all(:order => "name ASC")
    else
      @children = mg.item_types.all(:order => "name ASC", :select => "name, id")
    end
  end
end
