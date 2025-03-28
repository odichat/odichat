require "test_helper"

class Chatbots::SourcesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get chatbots_sources_edit_url
    assert_response :success
  end
end
