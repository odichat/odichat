require "test_helper"

class WabasControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get wabas_create_url
    assert_response :success
  end

  test "should get update" do
    get wabas_update_url
    assert_response :success
  end
end
