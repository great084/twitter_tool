require "time"
namespace :access_autotweet do
  desc "AutoTweetテーブルへアクセスする"
  task :auto_tweets => :environment do
    @now=Time.now.hour
     # 18:58 などにheroku schedulerが起動した際に、3分足すことで時間誤差を修正する
    @lag=Time.now+(60*3)  
    @time_lag=@lag.hour
    # Autotweetの時間と今の時間が一致しているか確認
    @autotweet_first=AutoTweet.where(tweet_hour1:@time_lag)
    @autotweet_second=AutoTweet.where(tweet_hour2:@time_lag)
    @autotweet_third=AutoTweet.where(tweet_hour3:@time_lag)
    @autotweet_fourth=AutoTweet.where(tweet_hour4:@time_lag)
    @autotweet_fifth=AutoTweet.where(tweet_hour5:@time_lag)
    @autotweets_array=[@autotweet_first,@autotweet_second,@autotweet_third,@autotweet_fourth,@autotweet_fifth]

    # 仮設定したメソッド
    def auto_tweet(user) 
      puts "auto_tweetメソッドへ引数渡す！"
      puts user.nickname
    end
    # auto_tweetを呼び出す
    def call_auto_tweet(autotweets)
      if autotweets
       autotweets.each do |autotweet|  
        @user= User.find_by(id: autotweet.user_id)
        auto_tweet(@user)
       end
      end
    end
    # call_auto_tweetを呼び出す
    @autotweets_array.each do |argument|
      call_auto_tweet(argument)
    end
 
  end
end



