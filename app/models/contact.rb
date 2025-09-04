class Contact < ApplicationRecord
  belongs_to :user

  before_create :generate_no

  validates :body,
    presence: true,
    length: { maximum: ContactConstants::BODY_LENGTH_MAX, allow_blank: true }

  private

  def generate_no
    # 16桁のランダム英数字
    begin
      self.no = SecureRandom.alphanumeric(ContactConstants::NO_LENGTH)
    end while Contact.exists?(no: self.no)
  end
end
