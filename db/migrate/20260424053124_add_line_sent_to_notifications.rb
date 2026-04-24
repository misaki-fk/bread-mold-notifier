class AddLineSentToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :line_sent, :boolean, default: false, null: false
  end
end
