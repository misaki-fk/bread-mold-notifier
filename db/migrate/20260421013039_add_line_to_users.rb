class AddLineToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :line_user_id, :string
    add_column :users, :line_notify_enabled, :boolean, default: false, null: false
  end
end
