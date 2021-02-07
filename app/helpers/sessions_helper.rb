module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:uid] = user.uid
  end

  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    return unless session[:uid]

    @current_user ||= User.find_by(uid: session[:uid])
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:uid)
    @current_user = nil
  end

  def before_query
    session[:search_query]
  end

  def next_search_query(search_params, response)
    if search_params["next"]
      session[:search_query] = search_params
      session[:last_search_created_at] = response["results"].last["created_at"]
    else
      session.delete(:search_query)
      session.delete(:last_search_created_at)
    end
  end
end
