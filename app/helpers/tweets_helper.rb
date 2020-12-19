module TweetsHelper
  def create_records(response)
    response["results"].each do |res|
      tweet = Tweet.find_by(tweet_id: res["id_str"])
      if tweet
        update_tweet_record(tweet, res)
      else
        create_tweet_record(res)
        extended_entities_exist(res["extended_entities"])
      end
    end
  end

  def create_tweet_record(res)
    Tweet.create!(
      user_id: current_user.id,
      tweet_created_at: res["created_at"],
      tweet_id: res["id_str"],
      text: res["text"],
      retweet_count: res["retweet_count"],
      favorite_count: res["favorite_count"]
    )
  end

  def update_tweet_record(tweet, res)
    tweet.update(
      retweet_count: res["retweet_count"],
      favorite_count: res["favorite_count"]
    )
  end

  def extended_entities_exist(extended_entities)
    return unless extended_entities

    extended_entities["media"].each do |res_medium|
      create_medium_record(res_medium)
    end
  end

  def create_medium_record(res_medium)
    Medium.create!(
      tweet_id: Tweet.last.id,
      media_url: res_medium["media_url"]
    )
  end
end
