class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show ]

  def index
    @second_categories = SecondCategory.all
    @products = Product.search(params).order(id: :desc).page(params[:page]).per(ProductConstants::PAGENATE_LIST_LIMIT)
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.released.find(params.expect(:id))
    end
end
