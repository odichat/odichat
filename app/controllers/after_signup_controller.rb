class AfterSignupController < ApplicationController
  layout "onboarding"
  include Wicked::Wizard
  include Pagy::Backend

  before_action :authenticate_user!
  helper_method :finish_wizard_path

  steps :create_chatbot, :create_faqs, :create_products

  def show
    @user = current_user

    case step
    when :create_chatbot
      @chatbot = @user.chatbots.build
    when :create_faqs
      load_faq_context
    when :create_products
      @chatbot = current_user.chatbots.includes(:products).last
      @pagy, @products = pagy(
        @chatbot.products.order(created_at: :asc),
        limit: 20
      )
      @product ||= @chatbot.products.build
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

    when :create_products
      @chatbot = current_user.chatbots.includes(:products).last
      @products = @chatbot.products
      @product ||= @chatbot.products.build

      if params[:document].present?
        handle_products_csv_upload
      else
        handle_manual_product_submission
      end

    else
      render_wizard @user
    end
  end

  private

  def finish_wizard_path
    last_chatbot = current_user.chatbots.order(created_at: :desc).first
    return chatbot_playground_path(last_chatbot) if last_chatbot.present?

    chatbots_path
  end

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
    @response = @chatbot.responses.build(response_params)
    if @response.save
      respond_to do |format|
        format.html { redirect_to wizard_path(:create_faqs), notice: "FAQ was successfully created." }
      end
    else
      @pagy, @responses = pagy_countless(@chatbot.responses.order(created_at: :desc), limit: 10)
      render_wizard @response, status: :unprocessable_entity
    end
  end

  # Handles new product creation, and product update.
  # If the `:id` is present, means it's a product update
  # If not present, we then go ahead and create a new product
  def handle_manual_product_submission
    if product_params[:id].present?
      @product = @chatbot.products.find(product_params[:id])
      success = @product.update(product_params)
      notice_msg = "Product was successfully updated."
    else
      @product = @chatbot.products.build(product_params)
      success = @product.save
      notice_msg = "Product was successfully created."
    end

    if success
      respond_to { |format| format.html { redirect_to wizard_path(:create_products), notice: notice_msg } }
    else
      render_wizard @product, status: :unprocessable_entity
    end
  end

  def handle_products_csv_upload
    file = params.dig(:document, :file)

    unless file.present?
      redirect_to wizard_path(:create_products), alert: "Please upload a CSV file." and return
    end

    tempfile = CsvUploadService.new(file).save_tempfile
    Products::ImportFromCsvJob.perform_later(
      tempfile,
      @chatbot.id,
      wizard_path(:create_products)
    )

    notice_message = "Processing CSV file... This may take a few minutes depending on the file size."

    respond_to do |format|
      format.html { redirect_to wizard_path(:create_products), notice: notice_message }
      format.turbo_stream do
        flash.now[:notice] = notice_message
        render turbo_stream: [
          turbo_stream.replace(
            "import_products_modal",
            partial: "after_signup/products/import_products_modal",
            locals: { chatbot: @chatbot, product: @product }
          ),
          turbo_stream.update(
            "products-table",
            partial: "chatbots/products/processing_loader",
            locals: { chatbot: @chatbot }
          ),
          turbo_stream.update("flash", partial: "shared/flash_messages")
        ]
      end
    end
  rescue StandardError => e
    Rails.logger.error("CSV upload failed: #{e.message}")
    redirect_to wizard_path(:create_products), alert: "Unable to process the CSV file. Please try again."
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

  def product_params
    params.require(:product).permit(:id, :name, :description, :price)
  end

  def load_faq_context
    @chatbot = current_user.chatbots.includes(:responses).last
    @responses = @chatbot.responses
    @pagy, @responses = pagy_countless(
      @responses.order(created_at: :desc),
      limit: 10
    )
    @response ||= @chatbot.responses.build
    @is_processing_documents = @chatbot.documents.pending.any?
  end
end
