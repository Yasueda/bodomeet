module Public::UsersHelper
  def user_owner?
    User.find(params[:id]).id == current_user.id
  end
end
