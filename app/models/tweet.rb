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
      uri = URI.parse("https://api.twitter.com/1.1/tweets/search/#{ENV['PLAN']}/#{ENV['LABEL']}.json")
      req_options = {
        use_ssl: uri.scheme == 'https'
      }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(fetch_request_data(uri, query_params))
      end
      JSON.parse(response.body)
    end

    def fetch_request_data(uri, query_params)
      request = Net::HTTP::Post.new(uri)
      request['Authorization'] = "Bearer #{ENV['BEARER_TOKEN']}"
      request.body = fetch_request_query(query_params)
      request
    end

    # apiに送るクエリの取得
    def fetch_query_params(form_params)
      date_query = writer_period_params(form_params[:period])
      query_params = form_params.merge!(date_query)
      query_params.merge!({ next: nil })
    end

    def writer_period_params(period)
      datetime = DateTime.now.gmtime
      case period
      when 'until_now' then
        {
          date_to: datetime.ago(0.years).strftime('%Y%m%d%H%M'),
          date_from: datetime.ago(27.days).strftime('%Y%m%d%H%M')
        }
      when 'until_one_year' then
        {
          date_to: datetime.ago(1.year).strftime('%Y%m%d%H%M'),
          date_from: datetime.ago(10.years).strftime('%Y%m%d%H%M')
        }
      end
    end

    # クエリ指定
    def fetch_request_query(query_params)
      "{
        \"query\":\"from:#{query_params[:login_user]}\",
        \"fromDate\":\"#{query_params[:date_from]}\",
        \"toDate\":\"#{query_params[:date_to]}\"
      }"
    end
  end
end
