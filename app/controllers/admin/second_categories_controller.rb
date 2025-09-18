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
        format.html { redirect_to [ :admin, @second_category ], notice: t("flash.actions.create.success", resource: SecondCategory.model_name.human) }
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
        format.html { redirect_to [ :admin, @second_category ], notice: t("flash.actions.update.success", resource: SecondCategory.model_name.human) }
        format.json { render :show, status: :ok, location: @second_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @second_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/second_categories/1 or /admin/second_categories/1.json
  def destroy
    if @second_category.products.exists?
      redirect_to admin_second_category_path(@second_category), alert: "製品情報が紐づいているため削除できません。"
    else
      @second_category.destroy!

      respond_to do |format|
        format.html { redirect_to admin_second_categories_path, status: :see_other, notice: t("flash.actions.destroy.success", resource: SecondCategory.model_name.human) }
        format.json { head :no_content }
      end
    end
  end

  def csv_upload
  end

  def csv_import
    uploaded_file = params[:csv_file]
    if uploaded_file.blank?
      redirect_to csv_upload_admin_second_categories_path, alert: "CSVファイルを選択してください" and return
    end

    invalid_rows  = []
    valid_records = []
    names_seen = Set.new

    begin
      # --- 検証フェーズ ---
      CSV.foreach(uploaded_file.tempfile.path, headers: true, encoding: "SJIS:UTF-8").with_index(2) do |row, line|
        parent_name  = row["大カテゴリ名"].to_s.strip
        child_name   = row["中カテゴリ名"].to_s.strip

        # 親カテゴリが存在するか
        parent = FirstCategory.find_by(name: parent_name)
        if parent.nil?
          invalid_rows << { line: line, errors: "大カテゴリ「#{parent_name}」が見つかりません" }
          next
        end

        # ファイル内重複チェック
        key = "#{parent.id}-#{child_name}"
        if names_seen.include?(key)
          invalid_rows << { line: line, errors: "同一ファイル内で中カテゴリ「#{child_name}」が重複しています" }
          next
        end
        names_seen.add(key)

        record = SecondCategory.new(
          name: child_name,
          first_category_id: parent.id
        )

        if record.valid?
          valid_records << record
        else
          # 最初のエラーだけ格納
          invalid_rows << { line: line, errors: record.errors.full_messages.first }
        end
      end
    rescue Encoding::UndefinedConversionError, Encoding::InvalidByteSequenceError => _
      # 文字コードが違う場合のエラーをキャッチ
      redirect_to csv_upload_admin_second_categories_path, alert: "CSVファイルの文字コードがシフトJISではありません" and return
    end

    if invalid_rows.any?
      # エラーがあれば再表示
      flash.now[:alert] = "エラーがあります。修正して再アップロードしてください"
      @errors = invalid_rows
      render :csv_upload and return
    end

    # --- バルクINSERT ---
    SecondCategory.import valid_records   # activerecord-import
    redirect_to admin_second_categories_path, notice: "中カテゴリを#{valid_records.size}件登録しました"
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
