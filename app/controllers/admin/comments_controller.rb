class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @comments = Comment.all
  end

  def active_switch
    comment = Comment.find(params[:id])
    if comment.update(is_active: !comment.is_active)
      redirect_to request.referer
    else
      redirect_to admin_root_path
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to action: :index, notice: "コメントを削除しました"
  end

  def destroy_all
    comments = Comment.where(is_active: false)
    comments.destroy_all
    redirect_to action: :index, notice: "無効コメントを全て削除しました"
  end
end
