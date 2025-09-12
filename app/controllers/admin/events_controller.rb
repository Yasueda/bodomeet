class Admin::EventsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @events = Event.all
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
  end

  def destroy_all
  end

  private

  def event_params
    params.require(:event).permit(:name, :introduction, :event_image, :date, :end_time, :venue, :min_people, :max_people, :is_active)
  end
end
