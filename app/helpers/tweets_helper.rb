module TweetsHelper
  def search_period(from, to)
    datetime = DateTime.now.gmtime
    {
      "date_from": datetime.ago(from).strftime("%Y%m%d%H%M"),
      "date_to": datetime.ago(to).strftime("%Y%m%d%H%M")
    }.to_json
  end

  def again_post_date(table)
    latest_date = table.last.created_at
    "#{latest_date.year}年#{latest_date.month}月#{latest_date.day}日"
  end

  def order_tweet_count
    tweet_count = []
    1.upto(RemaingNumber::REPETITION_NUMBER) do |count|
      tweet_count << (RemaingNumber::UNIT_NUMBER * count)
    end
    tweet_count
  end

  def before_query_first_day
    DateTime.parse(before_query["date_from"])
  end

  def before_query_last_day
    DateTime.parse(session[:last_search_created_at])
  end
end
