class RemoveIndextweetFromTweet < ActiveRecord::Migration[6.0]
  def change
    remove_index :tweets, column: :text
  end
end
