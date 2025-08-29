class Tag < ApplicationRecord
  has_many :product_tags, dependent: :restrict_with_error
  has_many :products, through: :product_tags

  validates :name,
    presence: true,
    length: { maximum: TagConstants::NAME_LENGTH_MAX, allow_blank: true },
    uniqueness: { allow_blank: true }

  def self.ransackable_attributes(auth_object = nil)
     %w[name]
  end

  def self.ransackable_associations(auth_object = nil)
     []
  end
end
