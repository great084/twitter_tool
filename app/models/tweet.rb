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
    def twitter_search_data(query_params)
      # client = twitter_client
      #Twitter developerのコード
      uri = URI.parse("https://api.twitter.com/1.1/tweets/search/#{ENV["PLAN"]}/#{ENV["LABEL"]}.json")
      req_options = {
        use_ssl: uri.scheme == "https",
      }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(fetch_request_data(uri, query_params))
      end
      return response = JSON.parse(response.body)
    end

    def set_period_params(period)
      datetime = DateTime.now
      if period == "until_now"
        params = {
          date_to: datetime.ago(3.month).strftime("%Y%m%d%H%M"),
          date_from: datetime.ago(1.years).strftime("%Y%m%d%H%M")
        }
      elsif period == "until_one_year"
        params = {
          date_to: datetime.ago(1.years).strftime("%Y%m%d%H%M"),
          date_from: datetime.ago(10.years).strftime("%Y%m%d%H%M")
        }
      end
    end

    def fetch_request_data(uri, query_params)
      request = Net::HTTP::Post.new(uri)
      request["Authorization"] = "Bearer #{ENV["BEARER_TOKEN"]}"
      request.body = fetch_request_query(query_params)
      request
    end

    #クエリ指定
    def fetch_request_query(query_params)
      body = "{
        \"query\":\"from:#{query_params[:login_user]}\",
        \"fromDate\":\"#{query_params[:date_from]}\",
        \"toDate\":\"#{query_params[:date_to]}\"
      }"
    end
  end
  # def twitter_client
  #   return client = Twitter::REST::Client.new do |config|
  #     config.consumer_key = ENV["TWITTER_API_KEY"]
  #     config.consumer_secret = ENV["TWITTER_API_SECRET"]
  #   end
  # end
end
