class SessionsController < ApplicationController
  include SessionsHelper

  def failure
    # flash[:alert] = "ログインをキャンセルしました。もう一度ログインしてください"
    redirect_to root_path, danger: "ログインをキャンセルしました。もう一度ログインしてください"
  end

  def create
    user_data = request.env["omniauth.auth"]
    if user_data[:uid]
      user = user_table_update(user_data)
      log_in(user)
      redirect_to root_url
    else
      redirect_to root_url, danger: "ログインできませんでした。もう一度ログインしてください"
      # flash[:alert] = "ログインできませんでした。もう一度ログインしてください"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def user_table_update(user_data)
    user = User.find_or_initialize_by(uid: user_data[:uid])
    user.update(
      nickname: user_data[:info][:nickname],
      token: user_data[:credentials][:token],
      secret: user_data[:credentials][:secret]
    )
    user
  end
end
