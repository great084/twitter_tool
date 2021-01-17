class TweetsController < ApplicationController
  include SessionsHelper
  include TwitterApi
  before_action :tweet_user, only: %i[show search retweet post_create]
  PER_PAGE = 10
  MEDIA_MAX_COUNT = 4
  require "date"
  require "open-uri"

  def index
    return if current_user.nil?

    @user = current_user
    @now = Time.zone.today
    if params[:q].present?
      @q = if params[:sorts]
             @user.tweets.ransack(sort_params)
           else
             @user.tweets.ransack(params[:q])
           end
    else
      params[:q] = { sorts: "tweet_created_at desc" }
      @q = @user.tweets.ransack
    end
    @tweets = @q.result(distinct: true)
                .order(tweet_created_at: :desc).includes(:media)
                .page(params[:page]).per(PER_PAGE)
  end

  def show
    @tweet = Tweet.find(params[:id])
    # 再投稿時の最大4件分の画像登録のためのオブジェクト生成
    media_count = @tweet.media.count
    (MEDIA_MAX_COUNT - media_count).times { @tweet.media.build }
    redirect_to root_path if @tweet.user_id != current_user.id
  end

  def search
    search_params = first_search_params
    return if search_params.instance_of?(String)  # 入力値が異常な場合 HTML文がsearch_paramsに返されるため

    old_tweet_counts = @user.tweets.count
    remaing_number = RemaingNumber.new(search_params["count"].to_i)
    loop do
      res_status, response = fetch_tweet(search_params)
      return if error_status?(res_status) || response_data_nil?(response)

      create_records(response)
      search_params.store("next", response["next"])
      if response["next"].nil? || remaing_number.lower_count.zero?
        next_search_query(search_params)
        break
      end
    end
    redirect_to root_path, success: "#{@user.tweets.count - old_tweet_counts}件のツイートを新しく取得しました"
  end

  def post_create
    @original_tweet = Tweet.find(params[:id])

    post_tweet(post_params, current_user)
    @original_tweet.update(tweet_flag: true)
    Repost.create!(tweet_id: @original_tweet.id)
    redirect_to tweet_path(@original_tweet), success: "再投稿に成功しました"
  rescue StandardError => e
    redirect_to tweet_path(@original_tweet), danger: "再投稿に失敗しました#{e} "
  end

  def retweet
    @tweet = Tweet.find_by(tweet_string_id: params_retweet[:tweet_string_id])
    post_retweet(params_retweet, current_user)
    @tweet.update(retweet_flag: true)
    Retweet.create!(tweet_id: @tweet.id)
    redirect_to tweet_path(@tweet), success: "リツイートに成功しました"
  rescue StandardError => e
    redirect_to tweet_path(@tweet), danger: "リツイートに失敗しました #{e}"
  end

  private

    def create_records(response)
      response["results"].each do |res|
        tweet = Tweet.find_by(tweet_string_id: res["id_str"])
        if tweet
          update_tweet_record(tweet, res)
        else
          create_tweet_record(res)
          extended_entities_exist(res["extended_entities"])
        end
      end
    end

    def create_tweet_record(res)
      tweet = Tweet.create!(
        user_id: current_user.id,
        tweet_created_at: res["created_at"],
        tweet_string_id: res["id_str"],
        text: res["text"],
        retweet_count: all_retweet_count(res),
        favorite_count: res["favorite_count"]
      )
      tweet.update(text: res["extended_tweet"]["full_text"]) if res["extended_tweet"].present?
    end

    def update_tweet_record(tweet, res)
      tweet.update(
        retweet_count: all_retweet_count(res),
        favorite_count: res["favorite_count"]
      )
    end

    def create_medium_record(res_medium)
      Medium.create!(
        tweet_id: Tweet.last.id,
        media_url: res_medium["media_url"]
      )
    end

    def extended_entities_exist(extended_entities)
      return unless extended_entities

      extended_entities["media"].each do |res_medium|
        create_medium_record(res_medium)
      end
    end

    def condition_params
      conditions = JSON.parse(params.require(:period))
      conditions.store("count", params.require(:count))
      conditions.store("login_user", current_user.nickname)
      conditions
    end

    def first_search_params
      return before_query if params[:commit] == "前回の続きから取得する"
      return condition_params if params[:commit] == "新しい条件を指定して取得する" && params[:period]

      redirect_to new_tweet_path, flash[:danger] = "期間が指定されていないため、入力し直してください"
    end

    def tweet_user
      redirect_to root_path, danger: "ログインしてください" if current_user.nil?
      @user = current_user
    end

    def response_data_nil?(response)
      !!if response["results"].empty?
          redirect_to new_tweet_path, danger: "指定した期間内にデータはありませんでした。"
        end
    end

    def post_params
      params.require(:tweet).permit(:text, media_attributes: [{ media_url: [] }, :id, :tweet_id])
    end

    def params_retweet
      params.require(:tweet).permit(:add_comments, :tweet_string_id)
    end

    def error_status?(res_status)
      !!if res_status[:code] != "200"
          redirect_to new_tweet_path, danger: "以下の理由でツイートを取得できませんでした。#{res_status[:message]}"
        end
    end

    def sort_params
      params.require(:q).permit(:sorts)
    end

    def all_retweet_count(res)
      res["retweet_count"] + res["quote_count"]
    end
end
