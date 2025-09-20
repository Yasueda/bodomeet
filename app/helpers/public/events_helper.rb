module Public::EventsHelper
  def event_owner?(event, id)
    event.user_id == id
  end
end
