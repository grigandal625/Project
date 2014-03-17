require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  test "should get get_task" do
    get :get_task
    assert_response :success
  end

end
