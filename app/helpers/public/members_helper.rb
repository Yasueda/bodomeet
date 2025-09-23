module Public::MembersHelper
  def member_group?(group_id)
    Member.where(user_id: current_user.id, group_id: group_id).exists?
  end
end
