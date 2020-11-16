class Tweet < ApplicationRecord
  belongs_to :user
  validates :tweet_created_at, presence: true
  validates :tweet_id, presence: true
  validates :text, presence: true
  validates :retweeted_count, presence: true
  validates :favorite_count, presence: true
  validates :tweet_flag, presence: true
  validates :retweet_flag, presence: true

end
