class DebugController < ApplicationController
  def exception
    raise "This raises an exception"
  end
end
