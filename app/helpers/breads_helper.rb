module BreadsHelper
  def line_share_url(bread)
    remaining = bread.remaining_count || 0

    share_text = <<~TEXT
🍞 Pankabi

🏠 家のパン情報
🍞 #{bread.bread_type.name}
⏰ #{bread.expiration_date.strftime('%Y.%m.%d')}
⭐️ #{remaining}枚

https://bread-mold-notifier.onrender.com
TEXT

    encoded_text = ERB::Util.url_encode(share_text.strip)

    if mobile_device?
      "https://line.me/R/share?text=#{encoded_text}"
    else
      "https://social-plugins.line.me/lineit/share?text=#{encoded_text}"
    end
  end

  private

  def mobile_device?
    request.user_agent.to_s.match?(/Mobile|Android|iPhone/)
  end
end