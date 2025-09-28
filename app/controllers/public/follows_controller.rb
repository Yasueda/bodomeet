class Public::FollowsController < ApplicationController
  def create
    follow = current_user.followeds.new(follower_id: params[:user_id])
    follow.save
    @user = User.find(params[:user_id])
  end

  def destroy
    follow = current_user.followeds.find_by(follower_id: params[:user_id])
    follow.destroy
    @user = User.find(params[:user_id])
  end
end
