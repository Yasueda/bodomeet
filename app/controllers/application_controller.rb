class ApplicationController < ActionController::Base
  before_action :set_paginate_per

  def set_paginate_per
    @users_per = 60
    @events_per = 24
    @comments_per = 10
    @groups_per = 8
    @user_show_events_per = 5
  end
end
