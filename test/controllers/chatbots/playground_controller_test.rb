require "test_helper"

class Chatbots::PlaygroundControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get chatbots_playground_show_url
    assert_response :success
  end

  test "should get update" do
    get chatbots_playground_update_url
    assert_response :success
  end
end
