class TweetsController < ApplicationController
  include SessionsHelper
  include TweetsHelper
  before_action :date_params_check, only: [:search]
  before_action :tweet_user, only: %i[show index search retweet]
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
      api_response = Tweet.fetch_tweet(query_params)
      res_status = Tweet.status_in_code(api_response)
      response = JSON.parse(api_response.body)
      return if error_status?(res_status) || response_data_nil?(response)

      create_records(response)
      break unless Tweet.next_token_exist(response, query_params)
    end
    redirect_to tweets_path
  end

  def date_params_check
    return if params.permit(:period).present?

    flash[:alert] = "期間が指定されていません。入力し直してください"
    redirect_to new_tweet_path
  end

  def retweet
    tweet = Tweet.find_by(tweet_id: params_retweet[:tweet_id])
    Tweet.post_add_comment_retweet(params_retweet, current_user)
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

    def tweet_user
      redirect_to root_path, flash: { alert: "ログインしてください" } if current_user.nil?
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

    def error_status?(res_status)
      !!if res_status[:code] != "200"
          flash[:alert] = "以下の理由でツイートを取得できませんでした。#{res_status[:message]}"
          redirect_to new_tweet_path
        end
    end
end
