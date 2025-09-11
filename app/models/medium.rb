class Medium < ApplicationRecord
  has_one_attached :image

  validates :media_flg,
    presence: true,
    inclusion: { in: MediaConstants::MEDIA_FLG_LIST.keys, allow_blank: true  }
  validates :image,
    attached: true,
    content_type: [ "image/png", "image/jpeg" ],
    size: { less_than_or_equal_to: MediaConstants::IMAGE_FILE_MAX.megabytes }
  validates :alt,
    presence: true,
    length: { maximum: MediaConstants::ALT_LENGTH_MAX, allow_blank: true }
  validates :url,
    presence: true,
    length: { maximum: MediaConstants::URL_LENGTH_MAX, allow_blank: true }
  validates :release_flg,
    presence: true,
    inclusion: { in: MediaConstants::RELEASE_FLG_LIST.keys, allow_blank: true }

  scope :carousels, -> {
    where(media_flg: MediaConstants::MEDIA_FLG_CAROUSEL,
          release_flg: MediaConstants::RELEASE_FLG_ON)
      .order(id: :desc)
  }

  scope :pick_ups, -> {
    where(media_flg: MediaConstants::MEDIA_FLG_PICKUP,
          release_flg: MediaConstants::RELEASE_FLG_ON)
      .order(id: :desc)
  }

  def self.ransackable_attributes(auth_object = nil)
     %w[media_flg alt release_flg]
  end

  def self.ransackable_associations(auth_object = nil)
     []
  end
end
