class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events, dependent: :destroy
  has_many :paticipants, dependent: :destroy
  has_many :events, through: :paticipants

  has_many :comments, dependent: :destroy
  has_many :events, through: :comments

  has_many :notifications, dependent: :destroy
  has_many :events, through: :notifications

  has_many :groups, dependent: :destroy

  has_many :members, dependent: :destroy
  has_many :groups, through: :members

  has_one_attached :user_image

  validates :name, length: {minimun: 2, maximum: 20}, uniqueness: true
  validates :introduction, length: {maximum: 200}
end
