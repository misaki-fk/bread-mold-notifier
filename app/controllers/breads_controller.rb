class BreadsController < ApplicationController
  before_action :set_bread, only: [:edit, :update]
  
  def new
    @bread = Bread.new
    @bread_types = BreadType.all
  end

  def create
    if user_signed_in?
      @bread = current_user.breads.build(bread_params)

      if @bread.save
        redirect_to home_path, notice: "パンを登録しました 🍞"
      else
        @bread_types = BreadType.all
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
  end

  def update
    if @bread.update(bread_params)
      redirect_to home_path, notice: "パンを更新しました 🍞"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_bread
    @bread = current_user.breads.find(params[:id])
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
