class CreateAutoTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :auto_tweets do |t|
      t.string :user_uid, null: false
      t.integer :tweet_hour1
      t.integer :tweet_hour2
      t.integer :tweet_hour3
      t.integer :tweet_hour4
      t.integer :tweet_hour5
      t.string :sort_column, null: false
      t.string :order, null: false
      t.integer :exclude_tweet, null: false
      t.integer :exclude_retweet, null: false
      t.integer :count, null: false

      t.timestamps
    end
  end
end
