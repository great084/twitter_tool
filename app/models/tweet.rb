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
  require "net/http"
  require "uri"
  require "json"

  class << self
    def twitter_search_data(query_params)
      uri = URI.parse("https://api.twitter.com/1.1/tweets/search/#{ENV['PLAN']}/#{ENV['LABEL']}.json")
      headers = { "Authorization": "Bearer #{ENV['BEARER_TOKEN']}", "Content-Type": "application/json" }
      data = {
        "query": "from:#{query_params[:login_user]}".to_s,
        "fromDate": query_params[:date_from].to_s,
        "toDate": query_params[:date_to].to_s
      }

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      request = Net::HTTP::Post.new(uri.request_uri, headers)
      request.body = JSON.generate(data)
      response = http.request(request)
      JSON.parse(response.body)
    end

    # apiに送るクエリの取得
    def fetch_query_params(form_params)
      date_query = period_params(form_params[:period])
      query_params = form_params.merge!(date_query)
      query_params.merge!({ next: nil })
    end

    def period_params(period)
      datetime = DateTime.now
      case period
      when "until_now"
        {
          date_to: datetime.ago(9.hours).strftime("%Y%m%d%H%M"),
          date_from: datetime.ago(28.days).strftime("%Y%m%d%H%M")
        }
      when period == "until_one_year"
        {
          date_to: datetime.ago(1.year).strftime("%Y%m%d%H%M"),
          date_from: datetime.ago(10.years).strftime("%Y%m%d%H%M")
        }
      end
    end

    def sent_query(query_params)
      data = {
        "query": "from:#{query_params[:login_user]}".to_s,
        "fromDate": query_params[:date_from].to_s,
        "toDate": query_params[:date_to].to_s
      }
      data.merge({ "next": query_params[:next].to_s }) if query_params[:next]
    end
  end
end
