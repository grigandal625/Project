require 'test_helper'

class OntologyRulesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ontology_rules_index_url
    assert_response :success
  end

  test "should get create" do
    get ontology_rules_create_url
    assert_response :success
  end

  test "should get update" do
    get ontology_rules_update_url
    assert_response :success
  end

  test "should get delete" do
    get ontology_rules_delete_url
    assert_response :success
  end

  test "should get execute" do
    get ontology_rules_execute_url
    assert_response :success
  end

end
