class Admin::ProductsController < Admin::ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    # @products = Product.all
    @second_categories = SecondCategory.all
    @products = Product.admin_search(params).order(id: :desc).page(params[:page]).per(ProductConstants::ADMIN_PAGENATE_LIST_LIMIT)
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    @second_categories = SecondCategory.all
  end

  # GET /products/1/edit
  def edit
    @second_categories = SecondCategory.all
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to [ :admin, @product ], notice: t("flash.actions.create.success", resource: Product.model_name.human) }
        format.json { render :show, status: :created, location: @product }
      else
        @second_categories = SecondCategory.all
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to [ :admin, @product ], notice: t("flash.actions.update.success", resource: Product.model_name.human) }
        format.json { render :show, status: :ok, location: @product }
      else
        @second_categories = SecondCategory.all
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to admin_products_path, status: :see_other, notice: t("flash.actions.destroy.success", resource: Product.model_name.human) }
      format.json { head :no_content }
    end
  end

  def bulk_destroy
    if params[:product_ids].present?
      begin
        Product.transaction do
          Product.where(id: params[:product_ids]).find_each(&:destroy!)
        end
        redirect_to admin_products_path, notice: "選択した製品情報を削除しました。"
      rescue => e
        Rails.logger.error("一括削除エラー: #{e.class} - #{e.message}")
        redirect_to admin_products_path, alert: "削除処理中にエラーが発生したため、削除は行われませんでした。"
      end
    else
      redirect_to admin_products_path, alert: "削除する製品情報を選択してください。"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def product_params
      permitted = params.expect(product: [ :first_category_id, :second_category_id, :name, :image, :detail, :release_flg, tag_ids: [] ])
      if permitted[:tag_ids].present?
        # 存在するタグIDだけ残す
        valid_ids = Tag.where(id: permitted[:tag_ids]).pluck(:id)
        permitted[:tag_ids] = valid_ids
      end

      if permitted[:first_category_id].present? && permitted[:second_category_id].present?
        exists = SecondCategory.exists?(
          id: permitted[:second_category_id],
          first_category_id: permitted[:first_category_id]
        )
        unless exists
          # 組み合わせが存在しなければエラーを追加
          permitted[:second_category_id] = nil # 保存されないようにする
        end
      end
      permitted
    end
end
