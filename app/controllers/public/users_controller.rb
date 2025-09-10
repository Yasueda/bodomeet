class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_corrent_user, only: [:update, :edit]
  before_action :ensure_guest_user, only: [:edit]

  def my_page
  end

  def index
  end

  def show
  end

  def edit
  end

  def update
  end

  def unsubcribe
  end

  def withdraw
  end

  private

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
