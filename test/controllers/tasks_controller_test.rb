require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  test "should get get_v" do
    get :get_v
    assert_response :success
  end

end
