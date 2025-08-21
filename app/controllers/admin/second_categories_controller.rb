class Admin::SecondCategoriesController < Admin::ApplicationController
  before_action :set_second_category, only: %i[ show edit update destroy ]

  # GET /admin/second_categories or /admin/second_categories.json
  def index
    # @second_categories = SecondCategory.all
    @q = SecondCategory.ransack(params[:q])
    @second_categories = @q.result(distinct: true).includes(:first_category).page(params[:page]).per(SecondCategoryConstants::ADMIN_PAGENATE_LIST_LIMIT)
  end

  # GET /admin/second_categories/1 or /admin/second_categories/1.json
  def show
  end

  # GET /admin/second_categories/new
  def new
    @second_category = SecondCategory.new
  end

  # GET /admin/second_categories/1/edit
  def edit
  end

  # POST /admin/second_categories or /admin/second_categories.json
  def create
    @second_category = SecondCategory.new(second_category_params)

    respond_to do |format|
      if @second_category.save
        format.html { redirect_to [:admin, @second_category], notice: t("flash.actions.create.success", resource: SecondCategory.model_name.human) }
        format.json { render :show, status: :created, location: @second_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @second_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/second_categories/1 or /admin/second_categories/1.json
  def update
    respond_to do |format|
      if @second_category.update(second_category_params)
        format.html { redirect_to [:admin, @second_category], notice: "Second category was successfully updated." }
        format.json { render :show, status: :ok, location: @second_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @second_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/second_categories/1 or /admin/second_categories/1.json
  def destroy
    @second_category.destroy!

    respond_to do |format|
      format.html { redirect_to admin_second_categories_path, status: :see_other, notice: t("flash.actions.destroy.success", resource: SecondCategory.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_second_category
      @second_category = SecondCategory.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def second_category_params
      params.expect(second_category: [ :first_category_id, :name ])
    end
end
