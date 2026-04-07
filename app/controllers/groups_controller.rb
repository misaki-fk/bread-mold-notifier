class GroupsController < ApplicationController
  before_action :authenticate_user!
  
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
    group = current_user.groups.find(params[:id])
    
    if group.default?
      redirect_to groups_path, alert: "マイストックは削除できません"
      return
    end
  
    group.destroy
  
    redirect_to groups_path, notice: "削除しました"
  end

  private

  def group_params
    params.require(:group).permit(:name, :description)
  end

end
