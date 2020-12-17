class TweetsController < ApplicationController
  include SessionsHelper
  before_action :date_params_check, only: [:search]
  before_action :tweet_user, only: %i[show index retweet]
  PER_PAGE = 10
  require "date"
  def index
    @q = Tweet.where(user_id: @user.id).ransack(params[:q])
    @tweets = @q.result(distinct: true)
                .order(tweet_created_at: :desc).includes(:media)
                .page(params[:page]).per(PER_PAGE)
    @now = Time.zone.today
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
      break unless Tweet.next_token_exist(response, query_params)
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

  def retweet
    tweet = Tweet.find_by(tweet_id: params_retweet[:tweet_id])
    post_add_comment_retweet(params_retweet)
    tweet.update(retweet_flag: true)
    redirect_to tweet_path(tweet), success: "リツイートに成功しました"
  rescue StandardError => e
    redirect_to tweet_path(tweet), danger: "リツイートに失敗しました #{e}"
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

    def response_data_nil?(response)
      !!if response["results"].empty?
          redirect_to new_tweet_path, flash: { alert: "指定した期間内にデータはありませんでした。" }
        end
    end

    def params_retweet
      params.require(:tweet).permit(:add_comments, :tweet_id)
    end

    def post_add_comment_retweet(params_retweet)
      client = Tweet.twitter_client(@user)
      old_tweet_url = "https://twitter.com/#{@user.nickname}/status/#{params_retweet[:tweet_id]}"
      client.update("#{params_retweet[:add_comments]}  #{old_tweet_url}")
    end
end
