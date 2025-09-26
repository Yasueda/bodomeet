class Public::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.event_id = params[:event_id]
    if @comment.save
      redirect_to event_path(params[:event_id])
    else
      @event = Event.find(params[:event_id])
      @comments = @event.comments.where(is_active: true)
      render "public/events/show"
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.update(is_active: :false)
    redirect_to event_path(params[:event_id]), notice: "コメントを削除しました"
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
