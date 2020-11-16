class AddIndexToTweet < ActiveRecord::Migration[6.0]
  def change
    add_index :tweets, [:tweet_created_at, :text,:retweet_count,:favorite_count,:tweet_flag,:retweet_flag]
  end
end
