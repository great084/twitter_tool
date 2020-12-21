class Tweet < ApplicationRecord
  belongs_to :user
  validates :tweet_created_at, presence: true
  validates :tweet_id, presence: true
  validates :text, presence: true
  validates :retweet_count, presence: true
  validates :favorite_count, presence: true
  validates :tweet_flag, inclusion: [true, false]
  validates :retweet_flag, inclusion: [true, false]
  has_many :media, dependent: :destroy
  class << self
    # apiに送るクエリの取得
    def post_add_comment_retweet(params_retweet, user)
      client = twitter_client(user)
      old_tweet_url = "https://twitter.com/#{user.nickname}/status/#{params_retweet[:tweet_id]}"
      client.update("#{params_retweet[:add_comments]}  #{old_tweet_url}")
    end

    def twitter_client(current_user)
      Twitter::REST::Client.new do |config|
        config.consumer_key = ENV["TWITTER_API_KEY"]
        config.consumer_secret = ENV["TWITTER_API_SECRET"]
        config.access_token = current_user.token
        config.access_token_secret = current_user.secret
      end
    end
  end
end
