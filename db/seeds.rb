# db/seeds.rb

# 既存のデータを削除してリセット（任意）
BreadType.destroy_all

# パンの種類を作成
["食パン", "ロールパン", "その他のパン"].each do |name|
  BreadType.create!(name: name)
end
