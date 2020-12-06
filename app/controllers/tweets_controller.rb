class TweetsController < ApplicationController
  include SessionsHelper
  before_action :date_params_empty?, only: [:search]
  before_action :tweet_user,only: [:show,:index]
  PER_PAGE = 10
  def index
    @q = Tweet.where(user_id: @user.id).ransack(params[:q])
    @tweets=@q.result(distinct: true).order(tweet_created_at: :desc).includes(:media).page(params[:page]).per(PER_PAGE)
    @now = Time.current 
  end

  def show
    @tweet = Tweet.find(params[:id])
    redirect_to root_path if @tweet.user_id != current_user.id
  end
  
  def search
    query_params = Tweet.fetch_query_params(form_params)
    response = Tweet.twitter_search_data(query_params)
    response["results"].each do |res|
      tweet = Tweet.find_by(tweet_id: res["id_str"])
      if tweet
        update_tweet_record(tweet, res)
      else
        create_tweet_record(res)
        is_extended_entities_exist?(res["extended_entities"])
      end
    end
    redirect_to tweets_path
  end

  def date_params_empty?
    if params.permit(:period).empty?
      flash[:alert] = '期間が指定されていません。入力し直してください'
      redirect_to new_tweet_path
    end
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

  def update_tweet_record(tweet, res)
    tweet.update(
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
  def tweet_user
    @user = current_user
  end
 
end


