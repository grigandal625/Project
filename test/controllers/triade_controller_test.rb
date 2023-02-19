require 'test_helper'

class TriadeControllerTest < ActionDispatch::IntegrationTest
  test "should get formate" do
    get triade_formate_url
    assert_response :success
  end

  test "should get list" do
    get triade_list_url
    assert_response :success
  end

  test "should get show" do
    get triade_show_url
    assert_response :success
  end

  test "should get relations" do
    get triade_relations_url
    assert_response :success
  end

end
