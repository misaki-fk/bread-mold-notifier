class Bread < ApplicationRecord
  has_many :notifications, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :bread_type
  belongs_to :group
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

  # データベースに保存後に通知を作成
  after_commit :notify_if_needed, on: [:create, :update]

  # 通知が必要かどうかを判断
  def notify_if_needed
    if expiration_date == Time.zone.today
      create_notification("expiration_today")
    end

    if daily_consumption > 0
      tomorrow_remaining = remaining_count - daily_consumption

      if tomorrow_remaining <= 0 && remaining_count > 0
        create_notification("run_out_tomorrow")
      end
    end
  end

  private

  def set_remaining_count
    self.remaining_count = total_count
  end

  # 通知を作成
  def create_notification(type)
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
      notified_at: Time.zone.now
    )
  end
end
