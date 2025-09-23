class Public::MembersController < ApplicationController
  def create
    member = current_user.members.new(group_id: params[:group_id])
    if member.save
      redirect_to request.referer
    else
      redirect_to root_path
    end
  end

  def destroy
    member = current_user.members.find_by(group_id: params[:group_id])
    member.destroy
    redirect_to request.referer
  end
end
