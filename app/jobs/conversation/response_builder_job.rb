class Conversation::ResponseBuilderJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.includes(chat: :chatbot).find(message_id)
    @chat = message.chat
    @messages = @chat.messages
    @chatbot = @chat.chatbot

    generate_and_process_response
  end

  private

    def generate_and_process_response
      @response = Chatbot::AgentRunnerService.new(chatbot: @chatbot, chat: @chat).generate_response(
        message_history: build_message_history
      )
      create_messages
    end

    def build_message_history
      @messages
        .order(created_at: :asc)
        .map do |message|
          {
            content: message.content,
            role: message.sender
          }
        end
    end

    def create_messages
      create_outgoing_message(@response[:response])
    end

    def create_outgoing_message(message_content)
      @chat.messages.create!(
        content: message_content,
        sender: "assistant",
        message_type: :auto,
        inbox: @chat.inbox
      )
    end
end
