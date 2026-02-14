class BreadType < ApplicationRecord
  has_many :breads

  validates :name, presence: true
end
