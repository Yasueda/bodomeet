class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
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
    user = User.find(params[:id])
    if user.update(is_active: !user.is_active)
      redirect_to request.referer
    else
      redirect_to admin_root_path
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to action: :index, notice: "ユーザーを削除しました。"
  end

  def destroy_all
    users = User.all
    users.each do |user|
      if user.is_active == false
        user.destroy
      end
    end
    redirect_to action: :index, notice: "退会済みのユーザーを全て削除しました。"
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :user_image, :is_active)
  end
end
