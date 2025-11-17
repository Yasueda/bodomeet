class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @comments = Comment.all.order(created_at: :desc).page(params[:page]).per(@comments_per)
  end

  def active_switch
    @comment = Comment.find(params[:id])
    @comment.update(is_active: !@comment.is_active)
  end

  def destroy
    comment = Comment.find(params[:id])
    event_id = params[:event_id] ? params[:event_id] : nil
    comment.destroy
    if event_id == nil
      redirect_to admin_comments_path, notice: "コメントを削除しました"
    else
      redirect_to admin_event_path(event_id), notice: "コメントを削除しました"
    end
  end

  def destroy_all
    comments = Comment.where(is_active: false)
    comments.destroy_all
    redirect_to admin_comments_path, notice: "無効コメントを全て削除しました"
  end
end
