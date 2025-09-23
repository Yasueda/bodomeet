module ApplicationHelper
  def current_id?(id)
    id == current_user.id
  end
end
