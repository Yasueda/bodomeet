class Admin::GroupsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @groups = Group.all
    @groups = Kaminari.paginate_array(@groups).page(params[:page]).per(@groups_per)
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to admin_group_path(@group), notice: "更新しました"
    else
      render :edit
    end
  end

  def active_switch
    @group = Group.find(params[:id])
    @group.update(is_active: !@group.is_active)
  end

  def destroy
    group = Group.find(params[:id])
    group.destroy
    redirect_to admin_groups_path, notice: "グループを削除しました"
  end

  def destroy_all
    groups = Group.where(is_active: false)
    groups.destroy_all
    redirect_to admin_groups_path, notice: "無効グループを全て削除しました"
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction)
  end
end
