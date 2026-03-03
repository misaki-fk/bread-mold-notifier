module BreadsHelper
  def line_share_url(bread)
    remaining = bread.remaining_count || 0
    share_text = <<~TEXT
    🏠【家のパンの情報】🏠

    🍞 #{bread.bread_type.name}
    ⏰ 消費期限: #{bread.expiration_date.strftime('%Y.%m.%d')}
    ⭐️ 残り枚数: #{remaining}枚
    TEXT

    encoded_text = ERB::Util.url_encode(share_text.strip)

    "https://social-plugins.line.me/lineit/share?url=#{encoded_text}"
  end
end