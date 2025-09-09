class ProductsController < ApplicationController
  def index
    @second_categories = SecondCategory.all
    @products = Product.search(params).order(id: :desc).page(params[:page]).per(ProductConstants::PAGENATE_LIST_LIMIT)
  end

  def show
  end
end
