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

    def next_token_exist(response, query_params)
      return unless response["next"]

      query_params[:next] = response["next"]
    end
  end
end
