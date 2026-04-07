class AddDefaultToGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :groups, :default, :boolean
  end
end
