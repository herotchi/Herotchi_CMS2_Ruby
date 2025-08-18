class FirstCategory < ApplicationRecord
  validates :name,
    presence: true,
    length: { maximum: FirstCategoryConstants::NAME_LENGTH_MAX, allow_blank: true }
end
