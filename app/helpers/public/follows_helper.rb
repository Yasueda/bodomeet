module Public::FollowsHelper
  def followed_user?(user_id)
    Follow.where(followed_id: current_user.id, follower_id: user_id).exists?
  end
end
