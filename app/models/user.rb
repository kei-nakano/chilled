class User < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  before_save { self.email = email.downcase }
  mount_uploader :image, ImageUploader
  validate :image_size
  validates :password, presence: true, length: { minimum: 8 }
  has_secure_password(validations: false)
  has_many :items, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy

  private

  # アップロード画像のサイズを検証する
  def image_size
    errors.add(:image, "should be less than 5MB") if image.size > 5.megabytes
  end
end
