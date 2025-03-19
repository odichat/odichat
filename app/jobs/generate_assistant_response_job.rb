class GenerateAssistantResponseJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.includes(:chat).find(message_id)
    chat = message.chat
    thread_id = chat.thread_id

    OpenAiService.add_message_to_thread(thread_id, message.sender, message.content)
    assistant_message = OpenAiService.create_and_wait_for_run(thread_id, chat.assistant_id)

    message = chat.messages.create!(
      sender: "assistant",
      content: assistant_message
    )

    puts "=" * 100
    puts "About to broadcast assistant message: #{message.id}"
    Rails.logger.info("About to broadcast assistant message: #{message.id}")

    # ================================
    # I couldn't use this becase it doesn't work with SQlite3.
    # At least, not that I know of.
    # So, for now I'm creating and endpoint and POSTing the message payload to it.
    # And then turbo_stream to the client.
    # This is a HACK, but it works.
    # TODO: Find a better solution.

    # Turbo::StreamsChannel.broadcast_append_to(
    #   "playground-messages",
    #   target: "playground-messages",
    #   partial: "messages/message",
    #   locals: { message: message }
    # )
    # ================================
  rescue StandardError => e
    Rails.logger.error("Error adding message to chat_id: #{message.chat.id} and thread_id: #{thread_id}: #{e.message}")
    raise "Error adding message to chat_id: #{message.chat.id} and thread_id: #{thread_id}: #{e.message}"
  end
end
