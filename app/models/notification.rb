class Notification < ApplicationRecord
  belongs_to :notified_user, class_name: "User"
  belongs_to :notified_event, class_name:"Event"
end
