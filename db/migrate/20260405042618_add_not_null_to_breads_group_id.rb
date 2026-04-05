class AddNotNullToBreadsGroupId < ActiveRecord::Migration[7.1]
  def change
    change_column_null :breads, :group_id, false
  end
end
