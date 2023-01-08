require 'test_helper'

class LikertUtzControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get likert_utz_new_url
    assert_response :success
  end

  test "should get show" do
    get likert_utz_show_url
    assert_response :success
  end

end
