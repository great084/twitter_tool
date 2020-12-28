module TweetsHelper
  def search_period(from, to)
    datetime = DateTime.now.gmtime
    {
      "date_from": datetime.ago(from).strftime("%Y%m%d%H%M"),
      "date_to": datetime.ago(to).strftime("%Y%m%d%H%M")
    }.to_json
  end
end
