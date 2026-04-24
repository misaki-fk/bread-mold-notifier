class Bread < ApplicationRecord
  has_many :notifications, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :bread_type
  validates :expiration_date, presence: true
  validates :total_count, presence: true
  validates :daily_consumption, presence: true,
  numericality: {
    only_integer: true, #小数なし
    greater_than: 0 # 0より大きい 
  }

  # 消費期限までの日数
  def days_until_expiration
    return nil unless expiration_date

    (expiration_date - Time.zone.today).to_i
  end

  # 残り枚数
  def remaining_count
    days_passed = (Time.zone.today - created_at.in_time_zone.to_date).to_i
    consumed = daily_consumption * days_passed
    remaining = total_count - consumed + adjustment_count
  end

  def increase_adjustment!
    increment!(:adjustment_count)
  end

  def decrease_adjustment!
    decrement!(:adjustment_count)
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

  after_commit :notify_if_needed, on: [:create, :update]


  private

  def set_remaining_count
    self.remaining_count = total_count
  end

  def notify_if_needed
    if expiration_date == Time.zone.today
      message = build_message("expiration_today")
      create_notification("expiration_today", message)
    end

    if daily_consumption > 0
      tomorrow_remaining = remaining_count - daily_consumption

      if tomorrow_remaining <= 0 && remaining_count > 0
        message = build_message("run_out_tomorrow")
        create_notification("run_out_tomorrow", message)
      end
    end
  end

  # メッセージ
  def build_message(type)
    greeting = greeting_message

    case type
    when "expiration_today"
      "#{greeting}\n\n📢 パンの消費期限が今日までです！\nお早めにご確認ください 👀"
    when "run_out_tomorrow"
      "#{greeting}\n\n📦 明日パンの在庫がなくなります！\n補充をお忘れなく 🛒"
    end
  end

  # あいさつメッセージ
  def greeting_message
    "おはようございます ☀️"
  end

  def create_notification(type, message)
    # 同じ通知が5分以内に作成されていたらスキップ
    return if Notification.exists?(
      bread: self,
      notification_type: type,
      created_at: 5.minutes.ago..Time.zone.now
    )

  Notification.create!(
    user: user,
    bread: self,
    notification_type: type,
    message: message,
    notified_at: Time.zone.now
  )
  end
end
