# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :is_active?, only: [:create]

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user.id), notice: "ゲストユーザーとしてログインしました。"
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def after_sign_in_path_for(resource)
    events_path
  end

  def after_sign_out_path_for(resource)
    about_path
  end

  def is_active?
    user = User.find_by(name: params[:user][:name])
    return if user.nil?
    return unless user.valid_password?(params[:user][:password])
    return if user.is_active
    redirect_to not_active_users_path
  end
end
