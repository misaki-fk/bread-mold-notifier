class GroupsController < ApplicationController
  before_action :authenticate_user!

  def switch
    group = current_user.groups.find(params[:id])
    session[:group_id] = group.id
    redirect_to home_path, notice: "グループを切り替えました"
  end
end
