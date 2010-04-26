class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  before_filter :set_title
  
  def set_title
    @title = action_name.titleize
  end
end
