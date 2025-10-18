class AfterSignupController < ApplicationController
  layout "onboarding"
  include Wicked::Wizard
  include Pagy::Backend

  before_action :authenticate_user!

  steps :create_chatbot, :create_faqs, :create_products, :test_playground, :connect_whatsapp

  def show
    @user = current_user

    case step
    when :create_chatbot
      @chatbot = @user.chatbots.build
    when :create_faqs
      load_faq_context
    when :create_products
    when :test_playground
    when :connect_whatsapp
    end

    render_wizard
  end

  def update
    @user = current_user

    case step
    when :create_chatbot
      @chatbot = build_chatbot_for(@user)
      render_wizard(@chatbot)
    when :create_faqs
      load_faq_context

      if params[:document].present?
        handle_document_upload
      else
        handle_manual_response_submission
      end

    else
      render_wizard @user
    end
  end

  private

  def handle_document_upload
    @document = @chatbot.documents.build(document_params)

    if @document.save
      @response = nil
      load_faq_context
      notice_message = "#{@document.file.blob.filename} is being processed..."

      respond_to do |format|
        format.html { redirect_to wizard_path(:create_faqs), notice: notice_message }
        format.turbo_stream do
          flash.now[:notice] = notice_message
          render turbo_stream: [
            turbo_stream.replace(
              "pdf_modal",
              partial: "after_signup/faqs/pdf_upload_modal",
              locals: { chatbot: @chatbot }
            ),
            turbo_stream.replace(
              dom_id(@chatbot, :responses_list),
              partial: "after_signup/faqs/responses_list",
              locals: {
                chatbot: @chatbot,
                responses: @responses,
                pagy: @pagy,
                is_processing_documents: @is_processing_documents,
                chatbot_response: @response
              }
            ),
            turbo_stream.update(
              "flash",
              partial: "shared/flash_messages"
            )
          ]
        end
      end
    else
      respond_to do |format|
        error_message = "Error uploading document. Try again."
        format.html { redirect_to wizard_path(:create_faqs), alert: error_message }
        format.turbo_stream do
          flash.now[:alert] = error_message
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages"), status: :unprocessable_entity
        end
      end
    end
  end

  def handle_manual_response_submission
    @response = @faq_agent.responses.build(response_params)
    if @response.save
      respond_to do |format|
        format.html { redirect_to wizard_path(:create_faqs), notice: "FAQ was successfully created." }
      end
    else
      @pagy, @responses = pagy_countless(@faq_agent.responses.order(created_at: :desc), limit: 10)
      render_wizard @response, status: :unprocessable_entity
    end
  end

  def build_chatbot_for(user)
    chatbot = user.chatbots.build(chatbot_params)
    chatbot.save
    chatbot
  end

  def chatbot_params
    params.require(:chatbot).permit(:name)
  end

  def response_params
    params.require(:response).permit(:question, :answer)
  end

  def document_params
    params.require(:document).permit(:file)
  end

  def load_faq_context
    @chatbot = current_user.chatbots.last
    @faq_agent = Roleable::Faq.find_by!(chatbot_id: @chatbot.id)
    @pagy, @responses = pagy_countless(
      @faq_agent.responses.order(created_at: :desc),
      limit: 10
    )
    @response ||= @faq_agent.responses.build
    @is_processing_documents = @chatbot.documents.pending.any?
  end
end
