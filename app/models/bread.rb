class Bread < ApplicationRecord
  belongs_to :user
  belongs_to :bread_type

  validates :daily_consumption,
  numericality: {
    only_integer: true, #小数なし
    greater_than: 0 # 0より大きい 
  }
end
