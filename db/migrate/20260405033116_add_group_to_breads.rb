class AddGroupToBreads < ActiveRecord::Migration[7.1]
  def change
    add_reference :breads, :group, foreign_key: true
  end
end
