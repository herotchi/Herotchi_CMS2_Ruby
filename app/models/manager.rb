class Manager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  devise :database_authenticatable, :registerable,
         :validatable, :authentication_keys: [ :login_id ]

  validates :login_id,
    presence: true,
    length: { minimum: ManagerConstants::LOGIN_ID_LENGTH_MIN, maximum: ManagerConstants::LOGIN_ID_LENGTH_MAX, allow_blank: true },
    uniqueness: { allow_blank: true }
end
