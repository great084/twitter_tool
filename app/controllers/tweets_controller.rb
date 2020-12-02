class TweetsController < ApplicationController
  include SessionsHelper

  def search
    date_query = Tweet.set_period_params(form_params[:period])
    query_params = form_params.merge!(date_query)
    response = Tweet.twitter_search_data(query_params)
    response["results"].each do |res|
      create_tweet_record(res)
      is_extended_entities_exist?(res["extended_entities"])
    end
    binding.pry
    redirect_to tweets_path
  end

  def index
    @tweets = Tweet.all
    @media = Medium.all
  end

  private
  def form_params
    params.permit(:period)
          .merge(login_user: current_user.nickname)
  end

  def create_tweet_record(res)
    Tweet.create!(
      user_id: current_user.id,
      tweet_created_at: res["created_at"],
      tweet_id: res["id_str"],
      text: res["text"],
      retweet_count: res["retweet_count"],
      favorite_count: res["favorite_count"]
    )
  end

  def is_extended_entities_exist?(extended_entities)
    if extended_entities
      extended_entities["media"].each do |res_midium|
        create_medium_record(res_midium)
      end
    end
  end

  def create_medium_record(res_midium)
    Medium.create!(
      tweet_id: Tweet.last.id,
      media_url: res_midium["media_url"]
    )
  end
end