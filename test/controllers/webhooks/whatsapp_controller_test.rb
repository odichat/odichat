require "test_helper"

class Webhooks::WhatsappControllerTest < ActionDispatch::IntegrationTest
  test "should get verify" do
    get webhooks_whatsapp_verify_url
    assert_response :success
  end

  test "should get process_payload" do
    get webhooks_whatsapp_process_payload_url
    assert_response :success
  end
end
