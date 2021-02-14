class AddExcludeRepostToAutoTweet < ActiveRecord::Migration[6.0]
  change_table :auto_tweets, bulk: true do |t|
    t.column :exclude_repost, :integer
    t.remove :exclude_tweet
  end
end
