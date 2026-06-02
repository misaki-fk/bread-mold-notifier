class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user
  
  def index
    @groups = current_user.groups
  end

  def show
    @group = current_user.groups.find(params[:id])
    @breads = @group.breads
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
  
    if @group.save
      # 自分をメンバーに追加（超重要🔥）
      @group.users << current_user
    
      # current_groupに設定
      session[:group_id] = @group.id
    
      redirect_to @group, notice: "グループを作成しました！"
    else
      render :new
    end
  end

  def switch
    group = current_user.groups.find(params[:id])
    session[:group_id] = group.id
    redirect_to home_path, notice: "グループを切り替えました"
  end

  def destroy
    @group = current_user.groups.find(params[:id])
    
    if @group.default?
      redirect_to group_path(@group), alert: "このグループは削除できません"
      return
    end
  
    if @group.destroy
      # セッションが削除したグループを指している場合はクリアする
      if session[:group_id].to_i == @group.id
        session.delete(:group_id)
      end

      redirect_to groups_path, notice: "グループを削除しました"
    else
      redirect_to group_path(@group), alert: "グループの削除に失敗しました"
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :description)
  end

end
