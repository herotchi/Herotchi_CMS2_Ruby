class Admin::TagsController < Admin::ApplicationController
  before_action :set_tag, only: %i[ show edit update destroy ]

  # GET /admin/tags or /admin/tags.json
  def index
    # @tags = Tag.all
    @q = Tag.ransack(params[:q])
    @tags = @q.result.page(params[:page]).per(TagConstants::ADMIN_PAGENATE_LIST_LIMIT)
  end

  # GET /admin/tags/1 or /admin/tags/1.json
  def show
  end

  # GET /admin/tags/new
  def new
    @tag = Tag.new
  end

  # GET /admin/tags/1/edit
  def edit
  end

  # POST /admin/tags or /admin/tags.json
  def create
    @tag = Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to [:admin, @tag], notice: t("flash.actions.create.success", resource: Tag.model_name.human) }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/tags/1 or /admin/tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to [:admin, @tag], notice: t("flash.actions.update.success", resource: Tag.model_name.human) }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tags/1 or /admin/tags/1.json
  def destroy
    @tag.destroy!

    respond_to do |format|
      format.html { redirect_to admin_tags_path, status: :see_other, notice: t("flash.actions.destroy.success", resource: Tag.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def tag_params
      params.expect(tag: [ :name ])
    end
end
