class Public::ParticipantsController < ApplicationController
  def create
    participant = current_user.participants.new(event_id: params[:event_id])
    if participant.save
      redirect_to request.referer
    else
      redirect_to root_path
    end
  end

  def destroy
    participant = current_user.participants.find_by(event_id: params[:event_id])
    participant.destroy
    redirect_to request.referer
  end
end
