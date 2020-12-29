module TweetsHelper
  def again_post_date(table)
    latest_date = table.last.created_at
    "#{latest_date.year}年#{latest_date.month}月#{latest_date.day}日"
  end
end
