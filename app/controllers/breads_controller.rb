class BreadsController < ApplicationController

  def new
    @bread = Bread.new
    @bread_types = BreadType.all
  end

  def create
    @bread = Bread.new(bread_params)
    @bread_types = BreadType.all

    if @bread.save
      redirect_to home_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def bread_params
    params.require(:bread).permit(
      :bread_type_id,
      :total_count,
      :daily_consumption,
      :expiration_date
    )
  end
end
