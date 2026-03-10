class ChangeDailyConsumptionInBreads < ActiveRecord::Migration[7.1]
  def change
    change_column :breads, :daily_consumption, :integer
  end
end