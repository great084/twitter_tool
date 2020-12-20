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

    def next_token_exist(response, query_params)
      return unless response["next"]

      query_params[:next] = response["next"]
    end
  end
end
