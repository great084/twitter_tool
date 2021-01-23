class SessionsController < ApplicationController
  include SessionsHelper

  def failure
    redirect_to users_path, danger: "ログインをキャンセルしました。もう一度ログインしてください"
  end

  def create
    user_data = request.env["omniauth.auth"]
    if user_data[:uid]
      user = user_table_update(user_data)
      log_in(user)
      redirect_to root_url
    else
      redirect_to users_path, danger: "ログインできませんでした。もう一度ログインしてください"
    end
  rescue StandardError => e
    put_api_error_log("login", "None", e)
    redirect_to root_url, danger: "ログインできませんでした。もう一度ログインしてください"
  end

  def destroy
    log_out if logged_in?
    redirect_to users_path
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
