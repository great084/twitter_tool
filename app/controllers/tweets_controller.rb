class TweetsController < ApplicationController
  include SessionsHelper
  before_action :date_params_check, only: [:search]
  before_action :tweet_user, only: %i[show index]
  before_action :twitter_client, only: [:post_create]

  PER_PAGE = 10
  def index
    @tweets = Tweet.where(user_id: @user.id)
                   .order(tweet_created_at: :desc).includes(:media)
                   .page(params[:page]).per(PER_PAGE)
  end

  def show
    @tweet = Tweet.find(params[:id])
    redirect_to root_path if @tweet.user_id != current_user.id
  end

  def search
    query_params = Tweet.fetch_query_params(form_params)
    loop do
      response = Tweet.fetch_tweet(query_params)
      return if response_data_nil?(response)

      create_records(response)
      break unless next_token_exist(response, query_params)
    end
    redirect_to tweets_path
  end

  def create_records(response)
    response["results"].each do |res|
      tweet = Tweet.find_by(tweet_id: res["id_str"])
      if tweet
        update_tweet_record(tweet, res)
      else
        create_tweet_record(res)
        extended_entities_exist(res["extended_entities"])
      end
    end
  end

  def date_params_check
    return unless params.permit(:period).empty?

    flash[:alert] = "期間が指定されていません。入力し直してください"
    redirect_to new_tweet_path
  end

  def post_new
    @tweet = Tweet.find(params[:id])
  end

  def post_create
    # 再投稿する
    @tweet = Tweet.new(post_params)
    if @tweet.text.blank?
      flash[:alert] = "空欄で投稿はできません。"
      render :post_new
    elsif @tweet.text.length >= 140
      flash[:alert] = "140字以内で投稿してください"
      render :post_new
    else
      @client.update("#{@tweet.text}\r")
      if @client.update("#{@tweet.text}\r")
        # 再投稿フラッグをtrueにする
        @tweet_flag = Tweet.find(params[:id])
        @tweet_flag.tweet_flag = true
        @tweet_flag.save
        redirect_to tweet_path(@tweet_flag)
        flash[:alert] = "再投稿しました"
      else
        flash[:alert] = "再投稿できませんでした"
        render :post_new
      end
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

    def extended_entities_exist(extended_entities)
      return unless extended_entities

      extended_entities["media"].each do |res_medium|
        create_medium_record(res_medium)
      end
    end

    def create_medium_record(res_medium)
      Medium.create!(
        tweet_id: Tweet.last.id,
        media_url: res_medium["media_url"]
      )
    end

    def tweet_user
      @user = current_user
    end

    def next_token_exist(response, query_params)
      return unless response["next"]

      query_params[:next] = response["next"]
    end

    def response_data_nil?(response)
      !!if response["results"].empty?
          redirect_to new_tweet_path, flash: { aler: "指定した期間内にデータはありませんでした。" }
        end
    end

    def post_params
      params.require(:tweet).permit(:text)
    end

    def twitter_client
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV["TWITTER_API_KEY"]
        config.consumer_secret = ENV["TWITTER_API_SECRET"]
        config.access_token = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
      end
    end
end
