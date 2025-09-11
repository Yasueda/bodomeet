class Public::EventsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @event = Event.new
  end

  def index
    @events = Event.all
  end

  def show
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      flash[:notice] = "新規イベントの作成に成功しました。"
      redirect_to event_path(@event.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def event_params
    params.require(:event).permit(:name, :introduction, :event_image, :date, :end_time, :venue, :min_people, :max_people)
  end
end
