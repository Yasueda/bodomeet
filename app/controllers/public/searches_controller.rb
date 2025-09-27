class Public::SearchesController < ApplicationController
  include SearchFunctions
  before_action :authenticate_user!

  def search
    if params[:keyword].empty? || params[:table].nil?
      redirect_to request.referer, alert: "検索ワードを入力してください"
    else
      case params[:table]
      when User.name
        @searches = User.where(is_active: true)
        @table = User.name
      when Event.name
        @searches = Event.where(is_active: true)
        @table = Event.name
      when Group.name
        @searches = Group.where(is_active: true)
        @table = Group.name
      else
        @table = nil
      end

      @searches = search_action(@searches, params[:keyword], @table)
    end
  end

end
