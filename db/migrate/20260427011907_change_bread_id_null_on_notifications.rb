class ChangeBreadIdNullOnNotifications < ActiveRecord::Migration[7.1]
  def change
    change_column_null :notifications, :bread_id, true
  end
end
