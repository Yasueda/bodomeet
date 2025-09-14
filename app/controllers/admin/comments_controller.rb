class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  def index
  end

  def active_switch
  end

  def destroy
  end

  def destroy_all
  end
end
