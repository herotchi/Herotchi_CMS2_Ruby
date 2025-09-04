class Contact < ApplicationRecord
  belongs_to :user

  before_create :generate_no

  validates :body,
    presence: true,
    length: { maximum: ContactConstants::BODY_LENGTH_MAX, allow_blank: true },
    on: :create
  validates :status,
    presence: true,
    inclusion: { in: ContactConstants::STATUS_LIST.keys, allow_blank: true },
    on: :update

  def self.ransackable_attributes(auth_object = nil)
     %w[no body created_at status]
  end

  def self.ransackable_associations(auth_object = nil)
     []
  end

  private

  def generate_no
    # 16桁のランダム英数字
    begin
      self.no = SecureRandom.alphanumeric(ContactConstants::NO_LENGTH)
    end while Contact.exists?(no: self.no)
  end
end
