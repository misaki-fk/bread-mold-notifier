class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bread, null: false, foreign_key: true
      t.string :notification_type, null:false
      t.string :message, null: false
      t.boolean :is_read, null: false, default: false
      t.datetime :notified_at, null: false

      t.timestamps
    end
  end
end
