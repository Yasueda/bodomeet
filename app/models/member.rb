class Member < ApplicationRecord
  belongs_to :user
  belongs_to :member_group, class_name: "Group"
end
