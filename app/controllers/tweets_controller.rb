class TweetsController < ApplicationController
  include SessionsHelper
  before_action :tweet_user
  PER_PAGE =10
  def index
    @tweets=Tweet.where(user_id: @user.id).order(id: :desc).includes(:media).page(params[:page]).per(PER_PAGE)
  end
  def show
   @tweet = Tweet.find(params[:id])
  end

  private
  def tweet_user
    @user=current_user
  end
end
