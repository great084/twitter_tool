class AddExcludeTweetToAutoTweet < ActiveRecord::Migration[6.0]
  change_table :auto_tweets, bulk: true do |t|
    t.column :exclude_tweet, :integer
    t.remove :exclude_retweet
  end
end
