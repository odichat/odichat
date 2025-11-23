class Chatbots::ProductsController < Chatbots::BaseController
  include Pagy::Backend
  before_action :set_product, only: %i[destroy edit update]

  def index
    @pagy, @products = pagy(
      @chatbot.products.order(created_at: :asc),
      limit: 20
    )
  end

  def new
  end

  def create
    @product = @chatbot.products.build(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to chatbot_products_path(@chatbot), notice: "Product was successfully created." }
      else
        format.html { redirect_to chatbot_products_path(@chatbot), alert: "Product could not be created"  }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to chatbot_products_path(@chatbot), notice: "Product was successfully updated." }
      else
        format.html { redirect_to chatbot_products_path(@chatbot), alert: "Product could not be updated." }
      end
    end
  end

  def destroy
    return unless @product

    if @product.destroy
      respond_to do |format|
        format.html { redirect_to chatbot_products_path(@chatbot), notice: "FAQ successfuly deleted." }
        format.turbo_stream do
          if params[:redirect].present?
            redirect_to params[:redirect], notice: "FAQ successfully deleted.", status: :see_other
          else
            @products = @chatbot.products
            flash.now[:notice] = "FAQ successfuly deleted."
            render turbo_stream: [
              turbo_stream.remove(@product),
              turbo_stream.update(
                "products-table",
                partial: "chatbots/products/table_or_empty",
                locals: { chatbot: @chatbot, products: @products, pagy: nil }
              ),
              turbo_stream.update("flash", partial: "shared/flash_messages")
            ]
          end
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to chatbot_products_path(@chatbot), alert: "Product could not be deleted" }
      end
    end
  end

  def import
    uploaded_file = params[:file]

    unless uploaded_file.present?
      return handle_csv_upload_error("Please upload a CSV file.")
    end

    unless csv_file?(uploaded_file)
      return handle_csv_upload_error("We only support CSV files. Please upload a CSV file.")
    end

    tempfile = CsvUploadService.new(uploaded_file).save_tempfile

    Products::ImportFromCsvJob.perform_later(
      tempfile,
      @chatbot.id,
      chatbot_products_path(@chatbot)
    )

    respond_to do |format|
      format.html do
        redirect_to chatbot_products_path(@chatbot),
          notice: "Processing CSV file... This may take a few minutes depending on the file size."
      end
      format.turbo_stream do
        flash.now[:notice] = "Processing CSV file... This may take a few minutes depending on the file size."
        render turbo_stream: [
          turbo_stream.replace(
            "import_products_modal",
            partial: "chatbots/products/import_products_modal"
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
  end

  private

    def set_product
      if @chatbot.nil?
        redirect_to chatbot_products_path(@chatbot), alert: "Product inventory not found." and return
      end

      @product = @chatbot.products.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to chatbot_products_path(@chatbot), alert: "Product not found." and return
    end

    def product_params
      params.require(:product).permit(:name, :description, :price)
    end

    def csv_file?(file)
      mime_type = file.content_type.to_s
      acceptable_types = %w[text/csv text/plain application/csv application/vnd.ms-excel]

      acceptable_types.include?(mime_type) || File.extname(file.original_filename.to_s).casecmp(".csv").zero?
    end

    def handle_csv_upload_error(message)
      respond_to do |format|
        format.html { redirect_to chatbot_products_path(@chatbot), alert: message }
        format.turbo_stream do
          flash.now[:alert] = message
          render turbo_stream: [
            turbo_stream.replace(
              "import_products_modal",
              partial: "chatbots/products/import_products_modal"
            ),
            turbo_stream.update("flash", partial: "shared/flash_messages")
          ]
        end
      end
    end
end
