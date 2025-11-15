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
                "products_table",
                partial: "chatbots/products/table_or_empty",
                locals: { products: @products }
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
end
