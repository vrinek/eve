require 'test_helper'

class DebugControllerTest < ActionController::TestCase
  test "should get dump" do
    get :dump
    assert_response :success
  end

end
