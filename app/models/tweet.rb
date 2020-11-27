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
    uri = URI.parse("https://api.twitter.com/1.1/tweets/search/#{ENV["PLAN"]}/#{ENV["LABEL"]}.json")
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(fetch_request_data(uri))
    end
    @response = JSON.parse(response.body)
  end


  def twitter_client
    return client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TWITTER_API_KEY"]
      config.consumer_secret = ENV["TWITTER_API_SECRET"]
    end
  end

  def fetch_request_data(uri)
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{ENV["BEARER_TOKEN"]}"
    request.body = fetch_request_query
    request
  end

  #クエリ指定
  def fetch_request_query
    body = "{
      \"query\":\"from:#{ENV["TWEET_USER"]}\",
      \"maxResults\":\"10\",
      \"fromDate\":\"202010290600\",
      \"toDate\":\"202010310900\"
    }"
  end

end