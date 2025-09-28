class Public::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  # before_action :ensure_guest_user, only: [:create, :edit, :update, :destroy]
  before_action :ensure_is_active, only: [:show, :edit, :update, :destroy]
  
  def new
    @event = Event.new
  end

  def index
    @events = Event.where(is_active: true)
    @month = params[:month] ? Date.parse(params[:month]) : nil
    if @month == nil
      @events = @events.asc_datetime_order
    else
      @events = @events.where(date: @month.all_month).asc_datetime_order
    end
    @events = Kaminari.paginate_array(@events).page(params[:page]).per(@events_per)
  end

  def show
    @event = Event.find(params[:id])
    @comment = Comment.new
    @comments = @event.comments.where(is_active: true)
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      flash[:notice] = "新規イベントを作成しました"
      redirect_to event_path(@event.id)
    else
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
    unless @event.since_event?
      redirect_to request.referer, alert: "過去のイベントは編集できません"
    end
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
    event.update(is_active: false)
    redirect_to events_path, notice: "削除しました"
  end

  def favorite
    @events = current_user.favorite_events.where(is_active: true)
    @events = Kaminari.paginate_array(@events).page(params[:page]).per(@events_per)
  end

  private

  def event_params
    params.require(:event).permit(:name, :introduction, :event_image, :date, :start_time, :end_time, :venue, :min_people, :max_people)
  end

  def ensure_correct_user
    user = Event.find(params[:id]).user
    unless user == current_user
      redirect_to events_path, alert: "このユーザーはその操作を行えません"
    end
  end

  def ensure_is_active
    event = Event.find(params[:id])
    unless event.is_active
      redirect_to events_path, alert: "そのイベントは削除されています"
    end
  end

  # ゲストユーザーアクセス制限用
  # def ensure_guest_user
  #   user = current_user
  #   if user.guest_user?
  #     redirect_to request.referer, alert: "ゲストユーザーはその操作を行えません"
  #   end
  # end
end
