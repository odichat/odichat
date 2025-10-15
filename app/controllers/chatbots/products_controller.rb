class Chatbots::ProductsController < Chatbots::BaseController
  before_action :set_product_inventory, only: %i[index create destroy edit update]
  before_action :set_product, only: %i[destroy edit update]

  def index
    @products = @product_inventory.products
  end

  def new
  end

  def create
    @product = @product_inventory.products.build(product_params)

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
      redirect_to chatbot_products_path(@chatbot), notice: "Product was successfully deleted."
    else
      redirect_to chatbot_products_path(@chatbot), alert: "Product could not be deleted."
    end
  end

  private

    def set_product_inventory
      @product_inventory = Roleable::ProductInventory.includes(:products).find_by(chatbot_id: @chatbot.id)
    end

    def set_product
      if @product_inventory.nil?
        redirect_to chatbot_products_path(@chatbot), alert: "Product inventory not found." and return
      end

      @product = @product_inventory.products.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to chatbot_products_path(@chatbot), alert: "Product not found." and return
    end

    def product_params
      params.require(:product).permit(:name, :description, :price)
    end
end
