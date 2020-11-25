class TweetsController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'
  include SessionsHelper

  def index
    tweet = Tweet.new()
    response = tweet.twitter_search_data
    response["results"].each do |res|
      Tweet.create!(
        user_id: current_user.id,
        tweet_created_at: res["created_at"],
        tweet_id: res["id_str"],
        text: res["text"],
        retweet_count: res["retweet_count"],
        favorite_count: res["favorite_count"]
      )
    end
    @tweets = Tweet.all
  end
end