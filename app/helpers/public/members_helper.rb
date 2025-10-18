module Public::MembersHelper
  def member_group?(group_id)
    Member.where(user_id: current_user.id, group_id: group_id).exists?
  end

  def is_approval_member?(group_id, user_id)
    member = Member.find_by(group_id: group_id, user_id: user_id)
    return member.is_approval
  end
end
