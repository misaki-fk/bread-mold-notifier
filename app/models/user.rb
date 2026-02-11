class User < ApplicationRecord
  has_many :breads, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ゲストユーザーを作成して返すメソッド
  def self.create_guest
    create!(
      email: "guest_#{Time.now.to_i}@example.com",
      password: SecureRandom.hex(10),
      guest: true
    )
  end
end
