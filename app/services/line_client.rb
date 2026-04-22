class LineClient
  def self.push_message(user, message)
    return if user.line_user_id.blank?

    uri = URI.parse("https://api.line.me/v2/bot/message/push")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri.request_uri)
    req["Authorization"] = "Bearer #{Rails.application.credentials.line[:channel_token]}"
    req["Content-Type"] = "application/json"

    req.body = {
      to: user.line_user_id,
      messages: [
        { type: "text", text: message }
      ]
    }.to_json

    http.request(req)
  end
end