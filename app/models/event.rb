class Event < ApplicationRecord
  belongs_to :user

  has_many :paticipants, dependent: :destroy
  has_many :users, through: :paticipants

  has_many :comments, dependent: :destroy
  has_many :users, through: :comments

  has_many :notifications, dependent: :destroy
  has_many :users, through: :notifications

  has_one_attached :event_image

  validates :name, length: {minimun: 2, maximum: 20}, uniqueness: true
  validates :introduction, length: {maximum: 200}
end
