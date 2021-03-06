namespace :access_autotweet do
  require "time"
  require "#{pwd}/app/lib/twitter_api"
  require "#{pwd}/app/lib/automation"
  include TwitterApi
  include Automation

  desc "AutoTweetテーブルへアクセスする"
  task auto_tweets: :environment do
    puts "##### heroku Schedulerによる定期的な処理を開始します。#####"
    @now = Time.zone.now.hour
    # 18:58 などにheroku schedulerが起動した際に、3分足すことで時間誤差を修正する
    @add_three_min = Time.zone.now + (60 * 3)
    @fix_timelag = @add_three_min.hour
    # Autotweetの時間と今の時間が一致しているか確認
    @autotweet_user_ids = AutoTweet.where("(tweet_hour1 = ?) OR (tweet_hour2 = ?)OR (tweet_hour3 = ?) OR (tweet_hour4 = ?) OR (tweet_hour5 = ?)", @fix_timelag, @fix_timelag, @fix_timelag, @fix_timelag, @fix_timelag).pluck(:user_id)

    # auto_tweetを呼び出す
    def call_auto_tweet(user_ids)
      user_ids.each do |user_id|
        @user = User.find_by(id: user_id)
        auto_tweet(@user)
      end
    end

    # call_auto_tweetを呼び出す
    call_auto_tweet(@autotweet_user_ids)
    puts "##### heroku Schedulerによる定期的な処理を終了します。#####"
  end
end
