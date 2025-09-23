class Admin::SearchesController < ApplicationController
  include SearchFunctions
  before_action :authenticate_admin!

  def search
    if params[:keyword].empty? || params[:table].nil?
      redirect_to request.referer
    else
      case params[:table]
      when User.name
        @searches = User.all
        @table = User.name
      when Event.name
        @searches = Event.all
        @table = Event.name
      when Comment.name
        @searches = Comment.all
        @table = Comment.name
      when Group.name
        @searches = Group.all
        @table = Group.name
      else
        @table = nil
      end

      @searches = search_action(@searches, params[:keyword], @table)
    end
  end
end
