class TweetsController < ApplicationController
  include SessionsHelper
  before_action :tweet_user
  PER_PAGE = 10
  def index
    @tweets = Tweet.where(user_id: @user.id).order(tweet_created_at: :desc).includes(:media).page(params[:page]).per(PER_PAGE)
  end

  def show
    @tweet = Tweet.find(params[:id])
    redirect_to root_path if @tweet.user_id != current_user.id
  end

  private

    def tweet_user
      @user = current_user
    end
end
