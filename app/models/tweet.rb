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
    def fetch_tweet(query_params)
      uri = URI.parse("https://api.twitter.com/1.1/tweets/search/#{ENV['PLAN']}/#{ENV['LABEL']}.json")
      headers = fetch_headers
      http = http_settings(uri)
      request = Net::HTTP::Post.new(uri.request_uri, headers)
      request.body = sent_query(query_params)
      response = http.request(request)
      JSON.parse(response.body)
    end

    # apiに送るクエリの取得
    def fetch_query_params(form_params)
      date_query = period_params(form_params[:period])
      form_params.merge!(date_query)

    end

    def period_params(period)
      datetime = DateTime.now.gmtime
      case period
      when "until_now"
        {
          date_to: datetime.strftime("%Y%m%d%H%M"),
          date_from: datetime.ago(1.year).strftime("%Y%m%d%H%M")
        }
      when "until_one_year"
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
      data.merge!({ "next": query_params[:next].to_s }) if query_params[:next]
      JSON.generate(data)
    end

    def fetch_headers
      {
        "Authorization": "Bearer #{ENV['BEARER_TOKEN']}",
        "Content-Type": "application/json"
      }
    end

    def http_settings(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http
    end
  end
end
