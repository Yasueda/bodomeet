class ApplicationController < ActionController::Base
  before_action :set_paginate_per

  def set_paginate_per
    @users_per = 60
    @events_per = 18
    @comments_per = 10
    @groups_per = 8
    @user_show_events_per = 5
    @user_groups_per = 5
  end

  def set_form_length
    @minimun_user_name_length = 2
    @maximun_user_name_lenght = 20
    @maximum_event_name_lenght = 30
  end
end
