require "csv"

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
        format.html { redirect_to [ :admin, @first_category ], notice: t("flash.actions.create.success", resource: FirstCategory.model_name.human) }
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
        format.html { redirect_to [ :admin, @first_category ], notice: t("flash.actions.update.success", resource: FirstCategory.model_name.human) }
        format.json { render :show, status: :ok, location: @first_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @first_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/first_categories/1 or /admin/first_categories/1.json
  def destroy
    if @first_category.second_categories.exists? || @first_category.products.exists?
      redirect_to admin_first_category_path(@first_category), alert: "中カテゴリや製品情報が紐づいているため削除できません。"
    else
      @first_category.destroy!

      respond_to do |format|
        format.html { redirect_to admin_first_categories_path, status: :see_other, notice: t("flash.actions.destroy.success", resource: FirstCategory.model_name.human) }
        format.json { head :no_content }
      end
    end
  end

  def csv_upload
  end

  def csv_import
    uploaded_file = params[:csv_file]
    if uploaded_file.blank?
      redirect_to csv_upload_admin_first_categories_path, alert: "CSVファイルを選択してください" and return
    end

    invalid_rows  = []
    valid_records = []
    names_seen = Set.new

    begin
      # --- 検証フェーズ ---
      CSV.foreach(uploaded_file.tempfile.path, headers: true, encoding: "SJIS:UTF-8").with_index(2) do |row, line|
        name = row["大カテゴリ名"].to_s.strip
        # ファイル内で重複している場合はエラー扱い
        if names_seen.include?(name)
          invalid_rows << { line: line, errors: "CSVファイル内で重複している大カテゴリ名があります" }
        end

        names_seen.add(name)

        record = FirstCategory.new(name: name)
        if record.valid?
          valid_records << record
        else
          invalid_rows << { line: line, errors: record.errors.full_messages.first }
        end
      end
    rescue Encoding::UndefinedConversionError, Encoding::InvalidByteSequenceError => _
      # 文字コードが違う場合のエラーをキャッチ
      redirect_to csv_upload_admin_first_categories_path, alert: "CSVファイルの文字コードがシフトJISではありません" and return
    end

    if invalid_rows.any?
      # エラーがあれば再表示
      flash.now[:alert] = "エラーがあります。修正して再アップロードしてください"
      @errors = invalid_rows
      render :csv_upload and return
    end

    # --- バルクINSERT ---
    FirstCategory.import valid_records   # activerecord-import
    redirect_to admin_first_categories_path, notice: "大カテゴリを#{valid_records.size}件登録しました"
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
