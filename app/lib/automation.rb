module Automation
  def choice_tweet(params, user)
    tweets = user.tweets
    last_tweet_date = Time.zone.now.ago(params.exclude_tweet.month)
    last_repost_date = Time.zone.now.ago(params.exclude_repost.month)
    exclude = Repost.where("created_at >= ?", last_repost_date).pluck(:tweet_id).uniq

    exclude_tweets = tweets.where("tweet_created_at <= ?", last_tweet_date).where.not(id: exclude)
    not_reply_tweets = exclude_tweets.where.not("text LIKE?", "@%")
    not_reply_tweets.order("#{params.sort_column} #{params.order}").first
  end

  def auto_tweet(user)
    Rails.logger.info "##### 現在時刻と再投稿希望時刻が一致したため処理を開始しました。#####"
    Rails.logger.info "##### user_name: #{user.nickname} #####"
    @params = AutoTweet.find_by(user_id: user.id)
    tweet_count = @params.count
    while tweet_count != 0
      tweet = choice_tweet(@params, user)
      unless tweet
        logger.error "該当のツイートが無いため、ツイートができませんでした。"
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
    Rails.logger.info "##### 再投稿が終了しました。再投稿件数: #{@params.count - tweet_count} #####"
  end
rescue StandardError => e
  Rails.logger.error "error_status: #{status}\rauto_tweet_error: #{error}"
end
