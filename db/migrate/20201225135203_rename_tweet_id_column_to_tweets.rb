class RenameTweetIdColumnToTweets < ActiveRecord::Migration[6.0]
  def change
    rename_column :tweets, :tweet_id, :tweet_string_id
  end
end
