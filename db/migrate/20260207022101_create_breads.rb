class CreateBreads < ActiveRecord::Migration[7.1]
  def change
    create_table :breads do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bread_type, null: false, foreign_key: true
      t.integer :total_count
      t.integer :remaining_count
      t.float :daily_consumption
      t.date :expiration_date

      t.timestamps
    end
  end
end
