class CreateDefaultBreads < ActiveRecord::Migration[7.1]
  def change
    create_table :default_breads do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.references :bread_type, null: false, foreign_key: true
      t.integer :total_count
      t.float :daily_consumption,null: false, default: 1

      t.timestamps
    end
  end
end
