class AddIndexToTweet < ActiveRecord::Migration[6.0]
  def change
    add_index :tweets, :tweet_created_at
    add_index :tweets, :text
    add_index :tweets, :retweet_count
    add_index :tweets, :favorite_count
    add_index :tweets, :tweet_flag
    add_index :tweets, :retweet_flag
  end
end
