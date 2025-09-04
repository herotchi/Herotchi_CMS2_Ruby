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

  private

  def devise_password_reset?
    reset_password_token.present?
  end
end
