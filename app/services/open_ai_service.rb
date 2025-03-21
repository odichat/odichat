require "openai"

class OpenAiService
  def self.create_thread
    begin
      client = OpenAI::Client.new
      thread = client.threads.create
      thread["id"]
    rescue OpenAI::Error => e
      Rails.logger.error("OpenAI error creating thread: #{e.message}")
      raise "OpenAI error creating thread: #{e.message}"
    end
  rescue StandardError => e
    # TODO: Make sure if this job fails, we send a notification and retry
    # I was getting a 500 error when I tried to create a thread. So this could happen often.
    Rails.logger.error("Unexpected error creating thread: #{e.message}")
    raise "Unexpected error creating thread: #{e.message}"
  end

  def self.add_message_to_thread(thread_id, role, message)
    begin
      Rails.logger.info("Adding message to thread: #{thread_id}")
      client = OpenAI::Client.new
      client.messages.create(
        thread_id: thread_id,
        parameters: {
          role: role,
          content: message
        }
      )["id"]
    rescue OpenAI::Error => e
      Rails.logger.error("OpenAI error adding message to thread: #{e.message}")
      raise "OpenAI error adding message to thread: #{e.message}"
    end
  rescue StandardError => e
    Rails.logger.error("Unexpected error adding message to thread: #{e.message}")
    raise "Unexpected error adding message to thread: #{e.message}"
  end

  def self.create_and_wait_for_run(thread_id, assistant_id)
    Rails.logger.info("Creating run")
    client = OpenAI::Client.new
    run = client.runs.create(
      thread_id: thread_id,
      parameters: { assistant_id: assistant_id }
    )

    while true do
      response = client.runs.retrieve(
        id: run["id"],
        thread_id: thread_id
      )
      status = response["status"]

      case status
      when "completed"
        new_messages = fetch_assistant_messages(thread_id, run["id"])
        return new_messages
      when "failed", "cancelled", "expired"
        error_message = "Run failed with status: #{status} and error: #{response["last_error"]}"
        Rails.logger.error(error_message)
        raise error_message
      when "requires_action"
        Rails.logger.info("Run requires action: #{response}")
        # tools_to_call = response.dig("required_action", "submit_tool_outputs", "tool_calls")
        # OpenAiToolHandler.handle_tool_calls(thread_id, run["id"], tools_to_call)
      when "queued", "in_progress", "cancelling"
        Rails.logger.info("Run #{status}: #{response}")
        sleep 1 # Wait one second and poll again
      else
        Rails.logger.info("Unknown status response: #{status} with response: #{response}")
        raise "Unknown status response: #{status} with response: #{response}"
      end
    end
  rescue StandardError => e
    Rails.logger.error("API call to OpenAI failed: #{e.message}")
    raise "API call to OpenAI failed: #{e.message}"
  end

  def self.get_assistant(assistant_id)
    client = OpenAI::Client.new
    client.assistants.retrieve(id: assistant_id)
  rescue OpenAI::Error => e
    Rails.logger.error("OpenAI error getting assistant: #{e.message}")
    raise "OpenAI error getting assistant: #{e.message}"
  end

  def self.update_assistant(assistant_id, model_id, temperature, system_instructions)
    client = OpenAI::Client.new
    model_name = Model.find(model_id).name
    client.assistants.modify(
      id: assistant_id,
      parameters: {
        model: model_name,
        temperature: temperature.to_f,
        instructions: system_instructions
      }
    )
  rescue OpenAI::Error => e
    Rails.logger.error("OpenAI error updating assistant: #{e.message}")
    raise "OpenAI error updating assistant: #{e.message}"
  end

  private

  def self.fetch_assistant_messages(thread_id, run_id)
    new_message_ids = fetch_message_ids_from_run(thread_id, run_id)
    new_messages = fetch_messages_by_ids(thread_id, new_message_ids)

    new_messages_text = new_messages.map do |msg|
      msg["content"].map do |content_item|
        case content_item["type"]
        when "text"
          content_item.dig("text", "value")
        else
          Rails.logger.warn("Unknown message content type: #{content_item["type"]}")
          nil
        end
      end.compact.join(" ")
    end.join(" ")

    new_messages_text
  end

  def self.fetch_message_ids_from_run(thread_id, run_id)
    client = OpenAI::Client.new
    run_steps = client.run_steps.list(
      thread_id: thread_id,
      run_id: run_id,
      parameters: { order: "asc" }
    )

    run_steps["data"].filter_map do |step|
      if step["type"] == "message_creation"
        step.dig("step_details", "message_creation", "message_id")
      end
    end
  end

  def self.fetch_messages_by_ids(thread_id, message_ids)
    client = OpenAI::Client.new
    message_ids.map do |msg_id|
      client.messages.retrieve(id: msg_id, thread_id: thread_id)
    end
  end
end
