class FirstCategory < ApplicationRecord
  has_many :second_categories, dependent: :restrict_with_error
  has_many :products

  validates :name,
    presence: true,
    length: { maximum: FirstCategoryConstants::NAME_LENGTH_MAX, allow_blank: true },
    uniqueness: { allow_blank: true }


  def self.ransackable_attributes(auth_object = nil)
     %w[name]
  end

  def self.ransackable_associations(auth_object = nil)
     []
  end
end
