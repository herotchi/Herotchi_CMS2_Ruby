class Tag < ApplicationRecord

  validates :name,
    presence: true,
    length: { maximum: TagConstants::NAME_LENGTH_MAX, allow_blank: true },
    uniqueness: { allow_blank: true }
end
