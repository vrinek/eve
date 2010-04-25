require 'test_helper'

class ToolsControllerTest < ActionController::TestCase
  test "should get compare_items" do
    get :compare_items
    assert_response :success
  end

end
