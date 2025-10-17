class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:not_active]
  before_action :ensure_guest_user, only: [:withdraw]
  # before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :ensure_is_active, only: [:show]

  def index
    @users = User.where(is_active: true).order(name: :asc)
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(@users_per)
  end

  def show
    @user = User.find(params[:id])
    @events = @user.events.where(is_active: true)
    @participated_events = @user.participated_events.where(is_active: true)

    @since_events = @events.get_since.asc_datetime_order
    @ago_events = @events.get_ago.desc_datetime_order
    @since_participated_events = @participated_events.get_since.asc_datetime_order
    @ago_participated_events = @participated_events.get_ago.desc_datetime_order
    
    @since_events = Kaminari.paginate_array(@since_events).page(params[:since_events_page]).per(@user_show_events_per)
    @ago_events = Kaminari.paginate_array(@ago_events).page(params[:ago_events_page]).per(@user_show_events_per)
    @since_participated_events = Kaminari.paginate_array(@since_participated_events).page(params[:since_participated_events_page]).per(@user_show_events_per)
    @ago_participated_events = Kaminari.paginate_array(@ago_participated_events).page(params[:ago_participated_events_page]).per(@user_show_events_per)
  end

  # showアクションに実装するとpaginateとjsonが競合するためcalenderアクションを分割
  def calender
    @user = User.find(params[:id])
    @events = @user.events.where(is_active: true)
    @participated_events = @user.participated_events.where(is_active: true)
    @calendar_events = @events + @participated_events
    respond_to do |format|
      format.json { render 'calendar' }
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(current_user.id), notice: "更新しました"
    else
      render :edit
    end
  end

  def unsubcribe
  end

  def withdraw
    user = current_user
    user.update(is_active: false)
    events = user.events.get_since
    events.each do |event|
      event.update(is_active: false)
    end
    groups = user.groups
    groups.each do |group|
      group.update(is_active: false)
    end
    reset_session
    redirect_to new_user_registration_path, notice: "退会しました"
  end

  def not_active
  end

  def followeds
    @users = User.find(params[:id]).followed_users.where(is_active: true).order(name: :asc)
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(@users_per)
  end

  def followers
    @users = User.find(params[:id]).follower_users.where(is_active: true).order(name: :asc)
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(@users_per)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :introduction, :user_image)
  end

  # ユーザーアクセス制限用
  # edit, update, withdraw, などでcurrent_userを指定しており
  # routesでも:idを含まない指定をしているので現状では不要
  # def ensure_correct_user
  #   user = User.find(params[:id])
  #   unless user == current_user
  #     redirect_to request.referer, notice: "このユーザーはその操作を行えません"
  #   end
  # end

  def ensure_guest_user
    user = current_user
    if user.guest_user?
      redirect_to request.referer, alert: "ゲストユーザーはその操作を行えません"
    end
  end

  def ensure_is_active
    user = User.find(params[:id])
    unless user.is_active
      redirect_to users_path, alert: "そのユーザーは退会しています"
    end
  end
end
