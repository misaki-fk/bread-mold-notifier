class BreadsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :set_bread, only: [:edit, :update, :increase, :decrease]
  before_action :set_bread_types, only: [:new, :edit, :create, :update]

  def new
    if current_group.default_bread.present?
      default = current_group.default_bread
  
      @bread = current_group.breads.build(
        bread_type_id: default.bread_type_id,
        total_count: default.total_count,
        daily_consumption: default.daily_consumption
      )
    else
      @bread = current_group.breads.build
    end
  end

  def create
    @bread = current_group.breads.build(bread_params)

    if @bread.save
      redirect_to home_path, notice: "パンを登録しました 🍞"
    else
      @bread_types = BreadType.all
      flash.now[:alert] = "入力に不備があります"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @bread.update(bread_params)
      redirect_to home_path, notice: "パンを更新しました 🍞"
    else
      @bread_types = BreadType.all
      flash.now[:alert] = "入力に不備があります"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bread = current_group.breads.find(params[:id])
    @bread.destroy
    redirect_to home_path, notice: "完食しました！ 🍞"
  end

  def increase
    @bread = current_group.breads.find(params[:id])
    @bread.increment!(:adjustment_count)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to home_path }
    end
  end

  def decrease
    @bread.decrement!(:adjustment_count)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to home_path }
    end
  end

  private

  def set_bread
    @bread = current_group.breads.find(params[:id])
  end

  def set_bread_types
    @bread_types = BreadType.all
  end

  def bread_params
    params.require(:bread).permit(
      :bread_type_id,
      :total_count,
      :daily_consumption,
      :expiration_date
    )
  end
end
