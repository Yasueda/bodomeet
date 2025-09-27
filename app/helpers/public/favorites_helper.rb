module Public::FavoritesHelper
  def favorite_event?(event_id)
    Favorite.where(user_id: current_user.id, event_id: event_id).exists?
  end
end
