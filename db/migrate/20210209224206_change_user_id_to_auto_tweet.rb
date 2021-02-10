class ChangeUserIdToAutoTweet < ActiveRecord::Migration[6.0]
  def change
    add_reference :auto_tweets, :user, foreign_key: true
    remove_column :auto_tweets, :user_uid, :string
  end
end
