class Public::FavoritesController < ApplicationController
  def create
    favorite = current_user.favorites.new(event_id: params[:event_id])
    favorite.save
    @event = Event.find(params[:event_id])
  end

  def destroy
    favorite = current_user.favorites.find_by(event_id: params[:event_id])
    favorite.destroy
    @event = Event.find(params[:event_id])
  end
end
