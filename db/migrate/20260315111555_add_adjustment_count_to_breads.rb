class AddAdjustmentCountToBreads < ActiveRecord::Migration[7.1]
  def change
    add_column :breads, :adjustment_count, :integer, default: 0, null: false 
  end
end
