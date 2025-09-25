class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @comments = Comment.all.order(created_at: :desc)
  end

  def active_switch
    @comment = Comment.find(params[:id])
    @comment.update(is_active: !@comment.is_active)
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to admin_comments_path, notice: "コメントを削除しました"
  end

  def destroy_all
    comments = Comment.where(is_active: false)
    comments.destroy_all
    redirect_to admin_comments_path, notice: "無効コメントを全て削除しました"
  end
end
