module Automation
  def choice_tweet(params, user)
    tweets = user.tweets
    last_tweet_date = Time.zone.now.ago(params.exclude_tweet.month)
    last_repost_date = Time.zone.now.ago(params.exclude_retweet.month)
    exclude = Repost.where("created_at >= ?", last_repost_date).pluck(:tweet_id).uniq

    exclude_tweets = tweets.where("tweet_created_at <= ?", last_tweet_date).where.not(id: exclude)
    not_reply_tweets = exclude_tweets.where.not("text LIKE?", "@%")
    not_reply_tweets.order("#{params.sort_column} #{params.order}").first
  end

  def auto_tweet(user)
    # テスト用パラメータ##############
    # AutoTweet.create!(
    #   user_id: user.id,
    #   tweet_hour1: 12,
    #   sort_column: "favorite_count",
    #   order: "desc",
    #   exclude_tweet: 1,
    #   exclude_retweet: 1,
    #   count: 2
    # )
    ############################

    @params = AutoTweet.find_by(user_id: user.id)    # 仮のユーザ
    binding.pry
    tweet_count = @params.count
    while tweet_count != 0
      tweet = choice_tweet(@params, user)
      unless tweet
        put_api_error_log("該当のツイートが無いため、ツイートができませんでした。")
        return
      end
      auto_post_params = {
        text: tweet.text,
        tweet_string_id: tweet.tweet_string_id
      }
      post_tweet(auto_post_params, user)
      tweet.update(tweet_flag: true)
      Repost.create!(tweet_id: tweet.id)
      tweet_count -= 1
    end
  rescue StandardError => e
    put_api_error_log("auto_tweet", status, e)
  end
end
