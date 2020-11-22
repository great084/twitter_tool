class TweetsController < ApplicationController
  def index
    @tweets=Tweet.order(id: :desc).includes(:media)

  end


end
