class BackfillGroupIdToBreads < ActiveRecord::Migration[7.1]
  def up
    User.find_each do |user|
      group = user.groups.first || user.groups.create!(name: "マイパン")
      user.breads.update_all(group_id: group.id)
    end
  end

  def down
    # 戻さないなら空でOK
  end
end
