class Product < ApplicationRecord
  belongs_to :first_category
  belongs_to :second_category
  has_many :product_tags, dependent: :destroy
  has_many :tags, through: :product_tags

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
    presence: true,
    inclusion: { in: ProductConstants::RELEASE_FLG_LIST.keys, allow_blank: true }

  # タグで絞り込み（すべて持つ）
  scope :by_tags, ->(tag_ids) {
    tag_ids = Array(tag_ids).reject(&:blank?) # 空文字やnilを削除
    if tag_ids.present?
      joins(:product_tags)
        .where(product_tags: { tag_id: tag_ids })
        .group("products.id")
        .having("COUNT(DISTINCT product_tags.tag_id) = ?", tag_ids.size)
    end
  }

  # カテゴリ（first）
  scope :by_first_category, ->(id) {
    where(first_category_id: id) if id.present?
  }

  # カテゴリ（second）
  scope :by_second_category, ->(id) {
    where(second_category_id: id) if id.present?
  }

  # 名前部分一致
  scope :by_name, ->(name) {
    where("products.name LIKE ?", "%#{name}%") if name.present?
  }

  # release_flg in検索
  scope :by_release_flg, ->(flgs) {
    where(release_flg: flgs) if flgs.present?
  }

  # 全体の検索メソッド
  def self.search(params)
    products = all
    products = products.by_tags(params[:tag_ids])
    products = products.by_first_category(params[:first_category_id])
    products = products.by_second_category(params[:second_category_id])
    products = products.by_name(params[:name])
    products = products.by_release_flg(params[:release_flg])
    products
  end
end
