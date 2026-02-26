class ChangeDailyConsumptionToInteger < ActiveRecord::Migration[7.1]
  def change
    change_column :default_breads, :daily_consumption, :integer, default: 1
  end
end
