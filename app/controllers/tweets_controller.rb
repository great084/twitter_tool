class TweetsController < ApplicationController
  def index
    @tweets=Tweet.order(id: :desc)
    #ユーザーを紐付ける
    # .includes(:user) 
  end

end
