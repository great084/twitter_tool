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
    # binding.pry
    session.delete(:uid)
    @current_user = nil
  end

  def before_query
    session[:search_query]
  end

  def next_search_query(search_params)
    return session[:search_query] = search_params if search_params["next"]

    session.delete(:search_query)
  end
end
