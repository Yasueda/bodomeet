class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  def index
    @users = User.all.order(name: :asc)
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(@users_per)
  end

  def show
    @user = User.find(params[:id])
    @events = @user.events
    @participated_events = @user.participated_events

    @since_events = @events.get_since.asc_datetime_order.first(@user_show_events_per)
    @ago_events = @events.get_ago.desc_datetime_order.first(@user_show_events_per)
    @since_participated_events = @participated_events.get_since.asc_datetime_order.first(@user_show_events_per)
    @ago_participated_events = @participated_events.get_ago.desc_datetime_order.first(@user_show_events_per)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user.id), notice: "編集に成功しました。"
    else
      render :edit
    end
  end

  def active_switch
    @user = User.find(params[:id])
    if @user.update(is_active: !@user.is_active)
      events = @user.events.get_since
      events.each do |event|
        event.update(is_active: false)
      end
      groups = @user.groups
      groups.each do |group|
        group.update(is_active: false)
      end
    end
  end

  def followeds
    @users = User.find(params[:id]).followed_users.order(name: :asc)
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(@users_per)
  end

  def followers
    @users = User.find(params[:id]).follower_users.order(name: :asc)
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(@users_per)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to admin_users_path, notice: "ユーザーを削除しました"
  end

  def destroy_all
    users = User.where(is_active: false)
    users.destroy_all
    redirect_to admin_users_path, notice: "退会済ユーザーを全て削除しました"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :introduction, :user_image, :is_active)
  end
end
