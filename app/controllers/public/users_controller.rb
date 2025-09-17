class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:not_active]
  before_action :ensure_guest_user, only: [:withdraw]
  # before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
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
    user.update(is_active: :false)
    reset_session
    redirect_to new_user_registration_path, notice: "退会しました"
  end

  def not_active
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :user_image)
  end

  # ユーザーアクセス制限用
  # edit, update, withdraw, などでcurrent_userを指定しており、
  # routesでも:idを含まない指定をしているので現状では不要
  #
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
end
