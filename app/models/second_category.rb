class SecondCategory < ApplicationRecord
  belongs_to :first_category
  has_many :products

  validates :first_category_id,
    presence: true
  validates :name,
    presence: true,
    length: { maximum: SecondCategoryConstants::NAME_LENGTH_MAX, allow_blank: true },
    uniqueness: { scope: :first_category_id, allow_blank: true }

  def self.ransackable_attributes(auth_object = nil)
     %w[first_category_id name]
  end

  def self.ransackable_associations(auth_object = nil)
     []
  end
end
