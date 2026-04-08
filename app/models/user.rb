class User < ApplicationRecord
  has_many :breads, dependent: :destroy
  has_one :default_bread, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships

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

  # ユーザー作成後に個人用グループを作成する
  after_create :create_personal_group

  def create_personal_group
    ActiveRecord::Base.transaction do
      group = Group.create!(
        name: "マイストック",
        default: true
      )
      memberships.create!(group: group)
    end
  end

end
