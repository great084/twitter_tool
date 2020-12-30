class Tweet < ApplicationRecord
  belongs_to :user
  validates :tweet_created_at, presence: true
  validates :tweet_string_id, presence: true
  validates :text, presence: true
  validates :retweet_count, presence: true
  validates :favorite_count, presence: true
  validates :tweet_flag, inclusion: [true, false]
  validates :retweet_flag, inclusion: [true, false]
  has_many :media, dependent: :destroy
  has_many :reposts, dependent: :destroy
  has_many :retweets, dependent: :destroy
end
