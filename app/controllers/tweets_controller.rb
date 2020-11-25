class TweetsController < ApplicationController
  PER_PAGE =5
  def index
    @tweets=Tweet.order(id: :desc).includes(:media).page(params[:page]).per(PER_PAGE)
  end
  def show
   @tweet = Tweet.find(params[:id])
  end

end
