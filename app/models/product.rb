class Product < ApplicationRecord
  belongs_to :first_category
  belongs_to :second_category
  has_and_belongs_to_many :tags
  has_one_attached :image

  validates :first_category_id,
    presence: true
  validates :second_category_id,
    presence: true
  validates :tag_ids,
    presence: true
  validates :tags,
    presence: true
  validates :name,
    presence: true,
    length: { maximum: ProductConstants::NAME_LENGTH_MAX, allow_blank: true }
  validates :image,
    attached: true,
    content_type: [ "image/png", "image/jpeg" ],
    size: { less_than_or_equal_to: ProductConstants::IMAGE_FILE_MAX.megabytes }
  validates :detail,
    presence: true,
    length: { maximum: ProductConstants::DETAIL_LENGTH_MAX, allow_blank: true }
  validates :release_flg,
    inclusion: { in: ProductConstants::RELEASE_FLG_LIST.keys, allow_blank: true }
end
