class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :content, length: {maximum: 100}
end
