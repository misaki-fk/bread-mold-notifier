# db/seeds.rb

# 既存のデータを削除してリセット（任意）
BreadType.destroy_all

# パンの種類を作成
["食パン", "ロールパン", "その他"].each do |name|
  BreadType.create!(name: name)
end

puts "パンの種類を初期登録しました！"
