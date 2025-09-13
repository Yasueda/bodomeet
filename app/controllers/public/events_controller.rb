class Public::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_currect_user, only: [:edit, :update, :destroy]
  
  def new
    @event = Event.new
  end

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def create
    byebug
    @event = current_user.events.new(event_params)
    if @event.save
      flash[:notice] = "新規イベントを作成しました。"
      redirect_to event_path(@event.id)
    else
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to event_path(@event), notice: "更新しました"
    else
      render :edit
    end
  end

  def destroy
    event = Event.find(params[:id])
    event.update(is_active: :false)
    redirect_to action: :index, notice: "削除しました"
  end

  private

  def event_params
    params.require(:event).permit(:name, :introduction, :event_image, :date, :end_time, :venue, :min_people, :max_people)
  end

  def ensure_correct_user
    user = Event.find(params[:id]).user
    unless user == current_user
      redirect_to events_path, notice: "このユーザーはその操作を行えません。"
    end
  end
end
