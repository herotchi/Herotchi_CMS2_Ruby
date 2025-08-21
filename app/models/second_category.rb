class SecondCategory < ApplicationRecord
  belongs_to :first_category

  validates :first_category_id,
    presence: true
  validates :name, 
    presence: true,
    uniqueness: { scope: :first_category_id, allow_blank: true }
end
