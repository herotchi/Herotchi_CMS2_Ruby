class Admin::ContactsController < Admin::ApplicationController
  before_action :set_contact, only: %i[ show update ]
  def index
    # --- CSVダウンロードボタンが押された場合 ---
    if params[:csv_export] == "csv_export"
      # 検索条件をセッションに保存
      session[:csv_export] = params[:q]   # 検索条件だけを保存する例

      # csv_export アクションへリダイレクト
      redirect_to csv_export_admin_contacts_path and return
    end

    @q = Contact.ransack(params[:q])
    @contacts = @q.result.page(params[:page]).order(id: :desc).per(ContactConstants::ADMIN_PAGENATE_LIST_LIMIT)
  end

  def show
  end

  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to [ :admin, @contact ], notice: t("flash.actions.update.success", resource: Contact.model_name.human) }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def csv_export
    # セッションから検索条件を取り出す
    params[:q] = session[:csv_export] || {}
    contacts = Contact.ransack(params[:q]).result.order(id: :asc)

    file_name = "お問い合わせ"

    # from/to の値を取り出す
    from = params[:q]["created_at_gteq"]
    to   = params[:q]["created_at_lteq"]

    # 条件分岐でファイル名を組み立て
    if from.present? && to.present?
      file_name += "#{from}～#{to}.csv"
    elsif from.present?
      file_name += "#{from}～.csv"
    elsif to.present?
      file_name += "～#{to}.csv"
    else
      file_name += ".csv"
    end

    # CSV生成 (Shift_JIS 例)
    csv_data = CSV.generate do |csv|
      csv << %w[お問い合わせNO 投稿日 氏名 メールアドレス お問い合わせ内容 ステータス]
      contacts.find_each do |c|
        csv << [ c.no, I18n.l(c.created_at, format: "%Y/%m/%d %H:%M:%S"), c.user.name, c.user.email, c.body, ContactConstants::STATUS_LIST[c.status] ]
      end
    end
    send_data csv_data.encode(Encoding::CP932, invalid: :replace, undef: :replace),
              filename: file_name,
              type: "text/csv; charset=Shift_JIS"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params.expect(:id))
    end

    def contact_params
      params.expect(contact: [ :status ])
    end
end
