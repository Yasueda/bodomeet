class Public::UsersController < ApplicationController
  before_action :authenticate_user!

  def my_page
  end

  def index
  end

  def show
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to my_page_path
    else
      render :edit
    end
  end

  def unsubcribe
  end

  def withdraw
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :user_image)
  end

  def ensure_corrent_user
    user = User.find(params[:id])
    unless user == current_user
      redirect_to my_page_path, notice: "this user cannot access"
    end
  end

  def ensure_guest_user
    user = User.find(params[:id])
    if user.gurst_user?
      redirect_to my_page_path, notice: "guest user cannot access"
    end
  end
end
