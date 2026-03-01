class DefaultBreadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_default_bread
  before_action :set_bread_types
  before_action :reject_guest_user

  def new
    # すでに設定があれば編集画面へ
    redirect_to edit_default_bread_path if @default_bread.present?

    @default_bread = current_user.build_default_bread
  end

  def create
    @default_bread = current_user.build_default_bread(default_bread_params)

    if @default_bread.save
      redirect_to home_path, notice: "いつも食べるパンを設定しました 🍞"
    else
      flash.now[:alert] = "入力に不備があります"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # 未設定なら新規作成へ
    redirect_to new_default_bread_path unless @default_bread
  end

  def update
    if @default_bread.update(default_bread_params)
      redirect_to home_path, notice: "いつも食べるパンを更新しました 🍞"
    else
      flash.now[:alert] = "入力に不備があります"
      render :edit, status: :unprocessable_entity
    end
  end

  def show
  if @default_bread.present?
    redirect_to edit_default_bread_path
  else
    redirect_to new_default_bread_path
  end
end

  private

  def set_default_bread
    @default_bread = current_user.default_bread
  end

  def set_bread_types
    @bread_types = BreadType.all
  end

  def default_bread_params
    params.require(:default_bread).permit(
      :bread_type_id,
      :total_count,
      :daily_consumption
    )
  end
end