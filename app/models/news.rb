class News < ApplicationRecord
  validates :title,
    presence: true,
    length: { minimum: NewsConstants::TITLE_LENGTH_MIN, maximum: NewsConstants::TITLE_LENGTH_MAX, allow_blank: true }
  validates :link_flg,
    presence: true,
    inclusion: { in: NewsConstants::LINK_FLG_LIST.keys, allow_blank: true }
  validates :release_date,
    presence: true,
    timeliness: {
      type: :date,
      on_or_after: Date.new(2023, 1, 1),
      on_or_before: Date.new(2037, 12, 31),
      allow_blank: true
    }
  validates :release_flg,
    presence: true,
    inclusion: { in: NewsConstants::RELEASE_FLG_LIST.keys, allow_blank: true }
  validates :url,
    presence: true,
    length: { maximum: NewsConstants::URL_LENGTH_MAX, allow_blank: true },
    if: -> { link_flg == NewsConstants::LINK_FLG_ON && errors[:link_flg].blank? }
  # link_flg が false かつ、link_flg にエラーがないときのみ overview をバリデート
  validates :overview,
    presence: true,
    length: { maximum: NewsConstants::OVERVIEW_LENGTH_MAX, allow_blank: true },
    if: -> { link_flg == NewsConstants::LINK_FLG_OFF && errors[:link_flg].blank? }

  def self.ransackable_attributes(auth_object = nil)
     %w[title link_flg release_date release_flg]
  end

  def self.ransackable_associations(auth_object = nil)
     []
  end


end
