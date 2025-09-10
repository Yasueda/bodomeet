class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:name]

  has_many :events, dependent: :destroy

  has_many :participants, dependent: :destroy
  has_many :participated_events, through: :participants

  has_many :comments, dependent: :destroy
  has_many :commented_events, through: :comments

  has_many :notifications, dependent: :destroy
  has_many :notified_events, through: :notifications

  has_many :groups, dependent: :destroy

  has_many :members, dependent: :destroy
  has_many :member_groups, through: :members

  has_one_attached :user_image

  validates :name, presence: true, length: {minimun: 2, maximum: 20}, uniqueness: true
  validates :introduction, length: {maximum: 200}

  def get_user_image
    (user_image.attached?) ? user_image : "no_user_image.png"
  end

  GUEST_USER_EMAIL = "guest@example.com"
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end
end
