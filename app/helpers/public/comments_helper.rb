module Public::CommentsHelper
  def comment_owner?(comment, id)
    comment.user_id == id
  end
end
