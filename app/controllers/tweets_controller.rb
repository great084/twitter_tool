class TweetsController < ApplicationController
  include SessionsHelper
  include TwitterApi
  before_action :date_params_check, only: [:search]
  before_action :tweet_user, only: %i[show search retweet post_create]
  PER_PAGE = 10
  require "date"
  def index
    tweet_user
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
    redirect_to root_path if @tweet.user_id != current_user.id
  end

  def search
    search_params = first_search_params
    old_tweet_counts = @user.tweets.count
    remaing_number = RemaingNumber.new(search_params["count"].to_i)
    loop do
      res_status, response = fetch_tweet(search_params)
      return if error_status?(res_status) || response_data_nil?(response)

      create_records(response)
      break if response["next"].nil? || remaing_number.lower_count.zero?

      search_params.store("next", response["next"])
    end
    redirect_to root_path, success: "#{@user.tweets.count - old_tweet_counts}件のツイートを新しく取得しました"
  end

  def date_params_check
    return if params.permit(:period).present?

    redirect_to new_tweet_path, danger: "期間が指定されていません。入力し直してください"
  end

  def post_create
    @tweet_data_all = Tweet.find(params[:id])
    post_tweet(post_params, @user)
    @tweet_data_all.tweet_flag = true
    @tweet_data_all.save
    Repost.create!(tweet_id: @tweet_data_all.id)
    redirect_to tweet_path(@tweet_data_all), success: "再投稿に成功しました"
  rescue StandardError => e
    redirect_to tweet_path(@tweet_data_all), danger: "再投稿に失敗しました#{e}"
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
        retweet_count: res["retweet_count"],
        favorite_count: res["favorite_count"]
      )
      tweet.update(text: res["extended_tweet"]["full_text"]) if res["extended_tweet"].present?
    end

    def update_tweet_record(tweet, res)
      tweet.update(
        retweet_count: res["retweet_count"],
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

    def first_search_params
      period = JSON.parse(params.require(:period))
      count = params.permit(:count)
      conditions = period.merge(count)
      conditions.store("login_user", current_user.nickname)
      conditions
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
      params.require(:tweet).permit(:text)
    end

    def params_retweet
      params.require(:tweet).permit(:add_comments, :tweet_string_id)
    end

    def error_status?(res_status)
      !!if res_status[:code] != "200"
          # flash[:alert] = "以下の理由でツイートを取得できませんでした。#{res_status[:message]}"
          redirect_to new_tweet_path, danger: "以下の理由でツイートを取得できませんでした。#{res_status[:message]}"
        end
    end

    def sort_params
      params.require(:q).permit(:sorts)
    end
end
