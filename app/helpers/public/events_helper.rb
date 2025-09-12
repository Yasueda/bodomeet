module Public::EventsHelper
  def event_owner?
    Event.find(params[:id]).user_id == current_user.id
  end
end
