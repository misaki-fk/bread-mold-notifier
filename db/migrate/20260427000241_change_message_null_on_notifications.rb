class ChangeMessageNullOnNotifications < ActiveRecord::Migration[7.1]
  def change
    change_column_null :notifications, :message, true
  end
end
