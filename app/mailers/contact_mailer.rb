class ContactMailer < ApplicationMailer
  default from: ENV["MAIL_FROM_ADDRESS"]

  def notify_user(contact, user)
    @contact = contact
    @user = user
    mail(
      to: @user.email,
      subject: "お問い合わせの登録が完了しました。"
    )
  end
end
