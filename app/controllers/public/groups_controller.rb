class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :ensure_is_active, only: [:show, :edit, :update, :destroy]

  def new
    @group = Group.new
  end

  def index
    @groups = Group.where(is_active: true)
  end

  def show
    @group = Group.find(params[:id])
  end

  def create
    @group = current_user.groups.new(group_params)
    @members = @group.members.where(is_active: true)
    if @group.save
      flash[:notice] = "新規グループを作成しました"
      redirect_to group_path(@group.id)
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to group_path(@group), notice: "更新しました"
    else
      render :edit
    end
  end

  def destroy
    group = Group.find(params[:id])
    group.update(is_active: false)
    redirect_to groups_path, notice: "削除しました"
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction)
  end

  def ensure_correct_user
    user = Group.find(params[:id]).user
    unless user == current_user
      redirect_to groups_path, notice: "このユーザーはその操作を行えません"
    end
  end

  def ensure_is_active
    group = Group.find(params[:id])
    unless group.is_active
      redirect_to groups_path, alert: "そのグループは削除されています"
    end
  end
end
