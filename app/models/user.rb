class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:name]

  has_many :events, dependent: :destroy

  has_many :participants, dependent: :destroy
  has_many :participated_events, through: :participants, source: :event

  has_many :comments, dependent: :destroy
  has_many :commented_events, through: :comments, source: :event

  has_many :notifications, dependent: :destroy
  has_many :notified_events, through: :notifications, source: :event

  has_many :groups, dependent: :destroy

  has_many :members, dependent: :destroy
  has_many :member_groups, through: :members, source: :group

  has_one_attached :user_image

  validates :name, presence: true, length: {minimun: 2, maximum: 10}, uniqueness: true
  validates :introduction, length: {maximum: 100}

  def get_user_image(width, height)
    unless user_image.attached?
      file_path = Rails.root.join('app/assets/images/no_user_image.png')
      user_image.attach(io: File.open(file_path), filename: 'default-user-image.png', content_type: 'image/png')
    end
    user_image.variant(resize_to_limit: [width, height]).processed
  end

  GUEST_USER_EMAIL = "guest@example.com"
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = ENV['GUEST_KEY']
      user.name = "ゲスト"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end
end
