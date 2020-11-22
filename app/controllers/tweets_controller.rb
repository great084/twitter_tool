class TweetsController < ApplicationController
  PER_PAGE = 10
  def index
    @tweets=Tweet.order(id: :desc).includes(:media).page(params[:page]).per(PER_PAGE)
  end


end
