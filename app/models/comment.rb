class Comment < ApplicationRecord
  belongs_to :commented_user, class_name: "User"
  belongs_to :commented_event, class_name: "Event"

  validates :content, length: {maximum: 50}
end
