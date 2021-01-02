class TweetsController < ApplicationController
  include SessionsHelper
  before_action :date_params_check, only: [:search]
  before_action :twitter_client, only: [:post_create]
  before_action :tweet_user, only: %i[show index search retweet]
  PER_PAGE = 10
  require "date"
  require "open-uri"

  def index
    @q = @user.tweets.ransack(params[:q])
    @tweets = @q.result(distinct: true)
                .order(tweet_created_at: :desc).includes(:media)
                .page(params[:page]).per(PER_PAGE)
    @now = Time.zone.today
  end

  def show
    @tweet = Tweet.find(params[:id])
    @tweet.media.build
    redirect_to root_path if @tweet.user_id != current_user.id
  end

  def search
    old_tweet_counts = @user.tweets.count
    query_params = Tweet.fetch_query_params(form_params)
    loop do
      api_response = Tweet.fetch_tweet(query_params)
      res_status = Tweet.status_in_code(api_response)
      response = JSON.parse(api_response.body)
      return if error_status?(res_status) || response_data_nil?(response)

      create_records(response)
      break unless Tweet.next_token_exist(response, query_params)
    end
    redirect_to tweets_path, success: "#{@user.tweets.count - old_tweet_counts}件のツイートを新しく取得しました"
  end

  def date_params_check
    return if params.permit(:period).present?

    flash[:alert] = "期間が指定されていません。入力し直してください"
    redirect_to new_tweet_path
  end

  def post_create
    @tweet = Tweet.new(post_params)
    @tweet_data_all = Tweet.find(params[:id])
    # @new_img=post_params[:media_attributes]["0"]["media_url"]
    post_params[:media_attributes]["0"]["media_url"].each do |media_url|
      @new_img= media_url
    end
    # 投稿画像のURLを取得
    @tweet_media = @tweet_data_all.media.pluck(:media_url)
    @img = @tweet_media.map { |img_url| URI.parse(img_url).open }
    @img.push(@new_img.path)

    @client.update_with_media("#{@tweet.text}\r",@img)


    @tweet_data_all.tweet_flag = true
    @tweet_data_all.save
    Repost.create!(tweet_id: @tweet_data_all.id)
    redirect_to tweet_path(@tweet_data_all), success: "再投稿に成功しました"
  rescue StandardError => e
    redirect_to tweet_path(params[:id]), danger: "再投稿に失敗しました#{e} "
binding.pry
  end

  def retweet
    @tweet = Tweet.find_by(tweet_string_id: params_retweet[:tweet_string_id])
    Tweet.post_add_comment_retweet(params_retweet, current_user)
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
      Tweet.create!(
        user_id: current_user.id,
        tweet_created_at: res["created_at"],
        tweet_string_id: res["id_str"],
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

    def form_params
      params.permit(:period)
            .merge(login_user: current_user.nickname)
    end

    def tweet_user
      redirect_to root_path, flash: { alert: "ログインしてください" } if current_user.nil?
      @user = current_user
    end

    def response_data_nil?(response)
      !!if response["results"].empty?
          redirect_to new_tweet_path, flash: { alert: "指定した期間内にデータはありませんでした。" }
        end
    end

    def post_params
      params.require(:tweet).permit(:text, :tweet,:tweet_string_id,media_attributes: [{ media_url: []}, :tweet_id ])
    end

    def twitter_client
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV["TWITTER_API_KEY"]
        config.consumer_secret = ENV["TWITTER_API_SECRET"]
        config.access_token = current_user.token
        config.access_token_secret = current_user.secret
      end
    end

    def params_retweet
      params.require(:tweet).permit(:add_comments, :tweet_string_id)
    end

    def error_status?(res_status)
      !!if res_status[:code] != "200"
          flash[:alert] = "以下の理由でツイートを取得できませんでした。#{res_status[:message]}"
          redirect_to new_tweet_path
        end
    end
end
