class AutoTweet < ApplicationRecord
  belongs_to :user
  validates :tweet_hour1, numericality: { allow_blank: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
  validates :tweet_hour2, numericality: { allow_blank: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
  validates :tweet_hour3, numericality: { allow_blank: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
  validates :tweet_hour4, numericality: { allow_blank: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
  validates :tweet_hour5, numericality: { allow_blank: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
  validates :sort_column, presence: true
  validates :order, presence: true
  validates :exclude_tweet, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :exclude_retweet, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :count, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
