class SessionsController < ApplicationController
  include SessionsHelper
  
  def create
    unless request.env['omniauth.auth'][:uid]
      redirect_to root_url
    end
    user_data = request.env['omniauth.auth']
    user = User.find_by(uid: user_data[:uid])
    if user
      log_in(user)
      redirect_to root_url
    else
      new_user = User.new(
        uid: user_data[:uid],
        nickname: user_data[:info][:nickname]
      )
      if new_user.save
        log_in(new_user)
      end
      redirect_to root_url
    end
  end


  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end