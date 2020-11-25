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


  def twitter_search_data
    client = twitter_client
    #Twitter developerのコード
    uri = URI.parse("https://api.twitter.com/1.1/tweets/search/30day/dev.json")

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{ENV["BEARER_TOKEN"]}"
    request.body = fetch_request_body
    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    @response = JSON.parse(response.body)
  end


  def twitter_client
    return client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TWITTER_API_KEY"]
      config.consumer_secret = ENV["TWITTER_API_SECRET"]
      config.access_token = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
  end

  def fetch_request

  end

  #クエリ指定
  def fetch_request_body
    body = "{
      \"query\":\"from:#{ENV["TWEET_USER"]}\",
      \"maxResults\":\"10\",
      \"fromDate\":\"202010281200\",
      \"toDate\":\"202011042000\"
    }"
  end

end