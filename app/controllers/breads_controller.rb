class BreadsController < ApplicationController

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
        render :new, status: :unprocessable_entity
      end
    else
      # ゲストはJS側で保存するので、Railsは何もしない
      redirect_to home_path, notice: "ゲストユーザーとしてパンを登録しました 🍞"
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
