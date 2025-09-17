require "csv"

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
        format.html { redirect_to [ :admin, @tag ], notice: t("flash.actions.create.success", resource: Tag.model_name.human) }
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
        format.html { redirect_to [ :admin, @tag ], notice: t("flash.actions.update.success", resource: Tag.model_name.human) }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tags/1 or /admin/tags/1.json
  def destroy
    if @tag.products.exists?
      redirect_to admin_tag_path(@tag), alert: "製品情報が紐づいているため削除できません。"
    else
      @tag.destroy!

      respond_to do |format|
        format.html { redirect_to admin_tags_path, status: :see_other, notice: t("flash.actions.destroy.success", resource: Tag.model_name.human) }
        format.json { head :no_content }
      end
    end
  end

  def csv_upload
  end

  def csv_import
    uploaded_file = params[:csv_file]
    if uploaded_file.blank?
      redirect_to csv_upload_admin_tags_path, alert: "CSVファイルを選択してください" and return
    end

    invalid_rows  = []
    valid_records = []
    names_seen = Set.new

    begin
      # --- 検証フェーズ ---
      CSV.foreach(uploaded_file.tempfile.path, headers: true, encoding: "SJIS:UTF-8").with_index(2) do |row, line|
        name = row["タグ名"].to_s.strip
        # ファイル内で重複している場合はエラー扱い
        if names_seen.include?(name)
          invalid_rows << { line: line, errors: "CSVファイル内で重複しているタグ名があります" }
        end

        names_seen.add(name)

        record = Tag.new(name: name)
        if record.valid?
          valid_records << record
        else
          invalid_rows << { line: line, errors: record.errors.full_messages.first }
        end
      end
    rescue Encoding::UndefinedConversionError, Encoding::InvalidByteSequenceError => _
      # 文字コードが違う場合のエラーをキャッチ
      redirect_to csv_upload_admin_tags_path, alert: "CSVファイルの文字コードがシフトJISではありません" and return
    end

    if invalid_rows.any?
      # エラーがあれば再表示
      flash.now[:alert] = "エラーがあります。修正して再アップロードしてください"
      @errors = invalid_rows
      render :csv_upload and return
    end

    # --- バルクINSERT ---
    Tag.import valid_records   # activerecord-import
    redirect_to admin_tags_path, notice: "タグを#{valid_records.size}件登録しました"
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
