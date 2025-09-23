class Admin::EventsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @events = Event.all.asc_datetime_order
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to admin_event_path(@event), notice: "更新しました"
    else
      render :edit
    end
  end

  def active_switch
    event = Event.find(params[:id])
    if event.update(is_active: !event.is_active)
      redirect_to request.referer
    else
      redirect_to admin_root_path
    end
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    redirect_to admin_events_path, notice: "イベントを削除しました"
  end

  def destroy_all
    events = Event.where(is_active: false)
    events.destroy_all
    redirect_to admin_events_path, notice: "無効イベントを全て削除しました"
  end

  def search
    if params[:keyword].empty?
      redirect_to request.referer
    else
      keywords = params[:keyword].split(/[[:blank:]]+/)
      @events = Event.all
      keywords.each do |keyword|
        next if keyword == ""
        @events = @events.search(keyword)
      end
      unless @events.empty?
        @events = @events.asc_datetime_order
      end
      render :index
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :introduction, :event_image, :date, :end_time, :venue, :min_people, :max_people, :is_active)
  end
end
