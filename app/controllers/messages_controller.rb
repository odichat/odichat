class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: %i[ show edit update destroy ]

  # GET /messages or /messages.json
  def index
    @messages = policy_scope(Message)
  end

  # GET /messages/1 or /messages/1.json
  def show
    authorize @message
  end

  # GET /messages/new
  def new
    @message = Message.new
    authorize @message
  end

  # GET /messages/1/edit
  def edit
    authorize @message
  end

  # POST /messages or /messages.json
  def create
    @message = Message.new(message_params)
    @chatbot = @message.chat.chatbot
    authorize @message

    respond_to do |format|
      if @message.save
        GenerateAssistantResponseJob.perform_later(@message.id) if @message.sender == "user"
        format.html { redirect_to chatbot_playground_path(@chatbot), notice: "Message was successfully created." }
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("messages", partial: "messages/message", locals: { message: @message })
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

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    authorize @message
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    authorize @message
    @message.destroy!

    respond_to do |format|
      format.html { redirect_to messages_path, status: :see_other, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.expect(message: [ :chat_id, :sender, :wa_message_id, :assistant_message_id, :content ])
    end
end
