class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :confirmable, :timeoutable

  validates :name, 
    presence: true, 
    length: { maximum: UserConstants::NAME_LENGTH_MAX, allow_blank: true },
    uniqueness: { allow_blank: true }

end
