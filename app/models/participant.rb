class Participant < ApplicationRecord
  belongs_to :participated_user, class_name: "User"
  belongs_to :participated_event, class_name: "Event"
end
