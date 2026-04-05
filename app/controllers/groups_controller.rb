class GroupsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @groups = current_user.groups
  end

  def show
    @invitation = Invitation.find_by!(token: params[:token])
    @group = @invitation.group
  end

  def new
    @group = Group.new
  end

  def create
    invitation = Invitation.find_by!(token: params[:token])
    invitation.group.users << current_user

    if invitation.group.save
      redirect_to invitation.group, notice: "作成しました"
    else
      render :new
    end
  end

  def switch
    group = current_user.groups.find(params[:id])
    session[:group_id] = group.id
    redirect_to home_path, notice: "グループを切り替えました"
  end

  private

  def group_params
    params.require(:group).permit(:name, :description)
  end

end
