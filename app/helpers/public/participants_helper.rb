module Public::ParticipantsHelper
  def participant_event?(event_id)
    Participant.where(user_id: current_user.id, event_id: event_id).exists?
  end
end
