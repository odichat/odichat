require "test_helper"

class Chatbots::SettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get chatbots_settings_show_url
    assert_response :success
  end

  test "should get update" do
    get chatbots_settings_update_url
    assert_response :success
  end
end
