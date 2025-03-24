require "test_helper"

class WaIntegrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get wa_integrations_create_url
    assert_response :success
  end

  test "should get update" do
    get wa_integrations_update_url
    assert_response :success
  end
end
