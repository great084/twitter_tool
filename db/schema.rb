# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_14_093738) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auto_tweets", force: :cascade do |t|
    t.integer "tweet_hour1"
    t.integer "tweet_hour2"
    t.integer "tweet_hour3"
    t.integer "tweet_hour4"
    t.integer "tweet_hour5"
    t.string "sort_column", null: false
    t.string "order", null: false
    t.integer "exclude_retweet", null: false
    t.integer "count", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.integer "exclude_repost"
    t.index ["user_id"], name: "index_auto_tweets_on_user_id"
  end

  create_table "media", force: :cascade do |t|
    t.bigint "tweet_id", null: false
    t.string "media_url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_id"], name: "index_media_on_tweet_id"
  end

  create_table "reposts", force: :cascade do |t|
    t.bigint "tweet_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_id"], name: "index_reposts_on_tweet_id"
  end

  create_table "retweets", force: :cascade do |t|
    t.bigint "tweet_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_id"], name: "index_retweets_on_tweet_id"
  end

  create_table "tweets", force: :cascade do |t|
    t.datetime "tweet_created_at", null: false
    t.string "tweet_string_id", null: false
    t.string "text", null: false
    t.integer "retweet_count", null: false
    t.integer "favorite_count", null: false
    t.bigint "user_id", null: false
    t.boolean "tweet_flag", default: false, null: false
    t.boolean "retweet_flag", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["favorite_count"], name: "index_tweets_on_favorite_count"
    t.index ["retweet_count"], name: "index_tweets_on_retweet_count"
    t.index ["retweet_flag"], name: "index_tweets_on_retweet_flag"
    t.index ["tweet_created_at"], name: "index_tweets_on_tweet_created_at"
    t.index ["tweet_flag"], name: "index_tweets_on_tweet_flag"
    t.index ["user_id"], name: "index_tweets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "nickname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token"
    t.string "secret"
  end

  add_foreign_key "auto_tweets", "users"
  add_foreign_key "media", "tweets"
  add_foreign_key "reposts", "tweets"
  add_foreign_key "retweets", "tweets"
  add_foreign_key "tweets", "users"
end
