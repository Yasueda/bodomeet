class Event < ApplicationRecord
  belongs_to :user

  has_many :participants, dependent: :destroy
  has_many :participated_users, through: :participants

  has_many :comments, dependent: :destroy
  has_many :commented_users, through: :comments

  has_many :notifications, dependent: :destroy
  has_many :notified_users, through: :notifications

  has_one_attached :event_image

  validates :name, presence: true, length: {minimun: 2, maximum: 20}, uniqueness: true
  validates :introduction, length: {maximum: 200}
end
