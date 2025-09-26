class Group < ApplicationRecord
  belongs_to :user

  has_many :members, dependent: :destroy
  has_many :users, through: :members

  has_one_attached :group_image

  validates :name, presence: true, length: {minimun: 2, maximum: 20}, uniqueness: { scope: :is_active }
  validates :introduction, length: {maximum: 200}
end
