class Admin::NewsController < Admin::ApplicationController
  before_action :set_news, only: %i[ show edit update destroy ]

  # GET /admin/news or /admin/news.json
  def index
    # @news = News.all
    @q = News.ransack(params[:q])
    @news = @q.result.page(params[:page]).per(NewsConstants::ADMIN_PAGENATE_LIST_LIMIT)
  end

  # GET /admin/news/1 or /admin/news/1.json
  def show
  end

  # GET /admin/news/new
  def new
    @news = News.new
  end

  # GET /admin/news/1/edit
  def edit
  end

  # POST /admin/news or /admin/news.json
  def create
    @news = News.new(news_params)

    respond_to do |format|
      if @news.save
        format.html { redirect_to [:admin, @news], notice: t("flash.actions.create.success", resource: News.model_name.human) }
        format.json { render :show, status: :created, location: @news }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/news/1 or /admin/news/1.json
  def update
    respond_to do |format|
      if @news.update(news_params)
        format.html { redirect_to [:admin, @news], notice: "News was successfully updated." }
        format.json { render :show, status: :ok, location: @news }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/news/1 or /admin/news/1.json
  def destroy
    @news.destroy!

    respond_to do |format|
      format.html { redirect_to admin_news_index_path, status: :see_other, notice: "News was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def news_params
      params.expect(news: [ :title, :link_flg, :url, :overview, :release_date, :release_flg ])
    end
end
