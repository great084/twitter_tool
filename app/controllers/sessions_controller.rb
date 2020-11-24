class SessionsController < ApplicationController
  include SessionsHelper

  def failure
    flash[:alert] = 'ログインをキャンセルしました。もう一度ログインしてください'
    redirect_to root_path
  end
  
  def create
    unless request.env['omniauth.auth'][:uid]
      redirect_to root_url
    end
    user_data = request.env['omniauth.auth']
    user = User.find_or_initialize_by(uid: user_data[:uid])
    user.update_attributes(nickname: user_data[:info][:nickname])
    log_in(user)
    redirect_to root_url
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end