class Bread < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :bread_type

  validates :daily_consumption,
  numericality: {
    only_integer: true, #小数なし
    greater_than: 0 # 0より大きい 
  }

  # 消費期限までの日数
  def  days_until_expiration
    return nil unless expiration_date

    (expiration_date - Date.today).to_i
  end

  # 残り枚数
  def remaining_count
    days_passed = (Date.current - created_at.to_date).to_i
    consumed = daily_consumption * days_passed
    remaining = total_count - consumed
  
    remaining.positive? ? remaining : 0
  end

  # 状態
def status_message
  return "完食しました🎉" if remaining_count.zero?

  case days_until_expiration
  when ..-1
    "危険です（自己責任）❗️"
  when 0
    "期限が今日までです⚠️"
  when 1
    "明日が消費期限です"
  else
    "まだ大丈夫です👍"
  end
end


end
