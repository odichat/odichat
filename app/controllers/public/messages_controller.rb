class Public::MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    @message.inbox = @message.chat.inbox
    @chatbot = @message.chat.chatbot

    respond_to do |format|
      if @message.save
        format.html { redirect_to chatbot_playground_path(@chatbot), notice: "Message was successfully created." }
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("messages", partial: "public/messages/message", locals: { message: @message })
        end
      else
        format.html { redirect_to chatbot_playground_path(@chatbot), status: :unprocessable_entity, alert: @message.errors.full_messages.join(", ") }
        format.turbo_stream do
          flash.now[:alert] = @message.errors.full_messages.to_sentence
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
        end
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:chat_id, :sender, :assistant_message_id, :content)
  end
end
