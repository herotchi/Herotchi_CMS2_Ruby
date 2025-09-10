class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :timeoutable

  has_many :contacts

  validates :name,
    presence: true,
    length: { maximum: UserConstants::NAME_LENGTH_MAX, allow_blank: true },
    uniqueness: { allow_blank: true },
    unless: :devise_password_reset?
  validates :user_policy,
    acceptance: { on: :create },
    unless: :devise_password_reset?

  # 論理削除
  def soft_delete
    update(deleted_at: Time.current)
  end

  # 削除済み判定
  def deleted?
    deleted_at.present?
  end

  # Devise ログイン可否判定
  def active_for_authentication?
    super && !deleted?
  end

  # ログイン不可時のメッセージ
  def inactive_message
    deleted? ? :deleted_account : super
  end

  private

  def devise_password_reset?
    reset_password_token.present?
  end
end
