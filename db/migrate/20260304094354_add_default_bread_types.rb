class AddDefaultBreadTypes < ActiveRecord::Migration[7.0]
  def up
    ["食パン", "ロールパン", "その他のパン"].each do |name|
      BreadType.find_or_create_by!(name: name)
    end
  end

  def down
    BreadType.where(name: ["食パン", "ロールパン", "その他のパン"]).delete_all
  end
end