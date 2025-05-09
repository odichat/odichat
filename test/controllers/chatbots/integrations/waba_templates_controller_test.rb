require "test_helper"

class Chatbots::Integrations::WabaTemplatesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chatbots_integrations_waba_templates_index_url
    assert_response :success
  end
end
