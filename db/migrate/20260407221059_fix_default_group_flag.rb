class FixDefaultGroupFlag < ActiveRecord::Migration[7.0]
  def up
    Group.reset_column_information

    User.find_each do |user|
      user.groups.update_all(default: false)
      user.groups.find_by(name: "マイストック")&.update(default: true)
    end
  end
end