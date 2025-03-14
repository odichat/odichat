require "application_system_test_case"

class ChatbotsTest < ApplicationSystemTestCase
  setup do
    @chatbot = chatbots(:one)
  end

  test "visiting the index" do
    visit chatbots_url
    assert_selector "h1", text: "Chatbots"
  end

  test "should create chatbot" do
    visit chatbots_url
    click_on "New chatbot"

    click_on "Create Chatbot"

    assert_text "Chatbot was successfully created"
    click_on "Back"
  end

  test "should update Chatbot" do
    visit chatbot_url(@chatbot)
    click_on "Edit this chatbot", match: :first

    click_on "Update Chatbot"

    assert_text "Chatbot was successfully updated"
    click_on "Back"
  end

  test "should destroy Chatbot" do
    visit chatbot_url(@chatbot)
    click_on "Destroy this chatbot", match: :first

    assert_text "Chatbot was successfully destroyed"
  end
end
