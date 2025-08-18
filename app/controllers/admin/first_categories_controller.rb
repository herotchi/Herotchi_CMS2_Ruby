class Admin::FirstCategoriesController < Admin::ApplicationController
  before_action :set_first_category, only: %i[ show edit update destroy ]

  # GET /admin/first_categories or /admin/first_categories.json
  def index
    # @first_categories = FirstCategory.all
    @q = FirstCategory.ransack(params[:q])
    @first_categories = @q.result.page(params[:page]).per(FirstCategoryConstants::ADMIN_PAGENATE_LIST_LIMIT)
  end

  # GET /admin/first_categories/1 or /admin/first_categories/1.json
  def show
  end

  # GET /admin/first_categories/new
  def new
    @first_category = FirstCategory.new
  end

  # GET /admin/first_categories/1/edit
  def edit
  end

  # POST /admin/first_categories or /admin/first_categories.json
  def create
    @first_category = FirstCategory.new(first_category_params)

    respond_to do |format|
      if @first_category.save
        format.html { redirect_to [:admin, @first_category], notice: t("flash.actions.create.success", resource: FirstCategory.model_name.human) }
        format.json { render :show, status: :created, location: @first_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @first_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/first_categories/1 or /admin/first_categories/1.json
  def update
    respond_to do |format|
      if @first_category.update(first_category_params)
        format.html { redirect_to [:admin, @first_category], notice: "First category was successfully updated." }
        format.json { render :show, status: :ok, location: @first_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @first_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/first_categories/1 or /admin/first_categories/1.json
  def destroy
    @first_category.destroy!

    respond_to do |format|
      format.html { redirect_to admin_first_categories_path, status: :see_other, notice: "First category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_first_category
      @first_category = FirstCategory.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def first_category_params
      params.expect(first_category: [ :name ])
    end
end
