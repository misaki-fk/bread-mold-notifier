class Group < ApplicationRecord
  validates :name, presence: true

  has_many :memberships
  has_many :users, through: :memberships

  has_many :breads, dependent: :destroy
end
