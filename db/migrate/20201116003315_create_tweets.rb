class CreateTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :tweets do |t|
      t.datetime :tweet_created_at, null: false
      t.string :tweet_id, null: false
      t.string :text, null: false
      t.integer :retweet_count, null: false
      t.integer :favorite_count, null: false
      t.references :user, null: false, foreign_key: true
      t.boolean :tweet_flag,default: false, null: false
      t.boolean :retweet_flag,default: false, null: false

      t.timestamps
    end
  end
end
