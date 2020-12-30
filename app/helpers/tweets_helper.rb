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
end
