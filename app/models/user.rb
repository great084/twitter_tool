class User < ApplicationRecord
  validates :uid, presence: true
  validates :nickname, presence: true
  has_many :tweets, dependent: :destroy
end
