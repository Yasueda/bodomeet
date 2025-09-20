module Public::UsersHelper
  def user_owner?(user, id)
    user.id == id
  end
end
