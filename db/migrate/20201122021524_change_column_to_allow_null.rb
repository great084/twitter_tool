class ChangeColumnToAllowNull < ActiveRecord::Migration[6.0]
  def up
    change_column :tweets, :tweet_flag,:boolean,default: false, null: true 
    change_column :tweets, :retweet_flag,:boolean,default: false, null: true 
  end

  def down
    change_column :tweets, :tweet_flag,:boolean,default: false, null: false 
    change_column :tweets, :retweet_flag,:boolean,default: false, null: false
  end
end