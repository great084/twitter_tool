class User < ApplicationRecord
  validates :uid, presence: true
  validates :nickname, presence: true
  validates :token, presence: true
  validates :secret, presence: true
  has_many :tweets, dependent: :destroy
  has_many :auto_tweets, dependent: :destroy
end
