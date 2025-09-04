class ContactsController < ApplicationController
  def new
    # セッションから復元
    if session[:contact].present?
      @contact = Contact.new(session[:contact])
    else
      @contact = Contact.new
    end
  end

  def confirm
    @contact = Contact.new(contact_params)
    @contact.user_id = current_user.id
    # render plain: @contact.errors.full_messages and return

    # バリデーションエラーがある場合は入力画面に戻す
    if @contact.invalid?
      render :new
    else
      # セッションに保存（DB保存はまだしない）
      session[:contact] = @contact.attributes
    end
  end

  def create
    if params[:back]
      # 確認画面から「戻る」が押された場合
      redirect_to new_contact_path
      return
    end

    @contact = Contact.new(session[:contact])
    @contact.status = ContactConstants::STATUS_NOT_STARTED # 未対応固定

    if @contact.save
      # ContactMailer.notify_user(@contact, current_user).deliver_now
      ContactMailer.notify_user(@contact, current_user).deliver_later

      # 完了画面用に番号をセッションに退避
      session[:last_contact_no] = @contact.no

      # 入力用セッションは破棄
      session.delete(:contact)

      redirect_to complete_contacts_path
    else
      render :new
    end
  end

  def complete
    if session[:last_contact_no].present?
      @contact_no = session[:last_contact_no]
      session.delete(:last_contact_no)
    else
      redirect_to root_path, alert: "セッション期限が切れました。"
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def contact_params
      params.expect(contact: [ :body ])
    end
end
