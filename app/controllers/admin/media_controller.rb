class Admin::MediaController < Admin::ApplicationController
  before_action :set_medium, only: %i[ show edit update destroy ]

  # GET /admin/media or /admin/media.json
  def index
    # @media = Medium.all
    @q = Medium.ransack(params[:q])
    @media = @q.result.page(params[:page]).per(MediaConstants::ADMIN_PAGENATE_LIST_LIMIT)
  end

  # GET /admin/media/1 or /admin/media/1.json
  def show
  end

  # GET /admin/media/new
  def new
    @medium = Medium.new
  end

  # GET /admin/media/1/edit
  def edit
  end

  # POST /admin/media or /admin/media.json
  def create
    @medium = Medium.new(medium_params)

    respond_to do |format|
      if @medium.save
        format.html { redirect_to [ :admin, @medium ], notice: t("flash.actions.create.success", resource: Medium.model_name.human) }
        format.json { render :show, status: :created, location: @medium }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/media/1 or /admin/media/1.json
  def update
    respond_to do |format|
      if @medium.update(medium_params)
        format.html { redirect_to [ :admin, @medium ], notice: t("flash.actions.update.success", resource: Medium.model_name.human) }
        format.json { render :show, status: :ok, location: @medium }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/media/1 or /admin/media/1.json
  def destroy
    @medium.destroy!

    respond_to do |format|
      format.html { redirect_to admin_media_path, status: :see_other, notice: t("flash.actions.destroy.success", resource: Medium.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medium
      @medium = Medium.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def medium_params
      params.expect(medium: [ :media_flg, :image, :alt, :url, :release_flg ])
    end
end
