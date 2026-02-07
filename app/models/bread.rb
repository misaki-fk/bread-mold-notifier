class Bread < ApplicationRecord
  belongs_to :user
  belongs_to :bread_type
end
