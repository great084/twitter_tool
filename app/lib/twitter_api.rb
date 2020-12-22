class TwitterApi
  class << self
    def fetch_tweet(search_params)
      uri = URI.parse("https://api.twitter.com/1.1/tweets/search/#{ENV['PLAN']}/#{ENV['LABEL']}.json")
      headers = fetch_headers
      http = http_settings(uri)
      request = Net::HTTP::Post.new(uri.request_uri, headers)
      request.body = sent_query(search_params)
      api_response = http.request(request)
      res_status = status_in_code(api_response)
      response = JSON.parse(api_response.body)
      [res_status, response]
    end

    def post_tweet(post_params, login_user)
      client = twitter_client(login_user)
      @tweet = Tweet.new(post_params)
      client.update("#{@tweet.text}\r")
    end

    def post_retweet(params_retweet, login_user)
      client = twitter_client(login_user)
      old_tweet_url = "https://twitter.com/#{login_user.nickname}/status/#{params_retweet[:tweet_id]}"
      client.update("#{params_retweet[:add_comments]}  #{old_tweet_url}")
    end

    def fetch_headers
      {
        "Authorization": "Bearer #{ENV['BEARER_TOKEN']}",
        "Content-Type": "application/json"
      }
    end

    def http_settings(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http
    end

    def sent_query(search_params)
      data = {
        "query": "from:#{search_params['login_user']}",
        "fromDate": search_params["date_from"],
        "toDate": search_params["date_to"]
      }
      data.merge!({ "next": search_params["next"] }) if search_params["next"]
      JSON.generate(data)
    end

    def status_in_code(response)
      statuses =
        { code: "200", message: "データの取得に成功しました。" },
        { code: "400", message: "リクエストが不正です。" },
        { code: "401", message: "アクセスには認証が必要です。" },
        { code: "403", message: "このリソースへのアクセスは許可されておりません。" },
        { code: "404", message: "リソースが見つかりませんでした。URLが間違っている可能性があります。" },
        { code: "422", message: "入力値が無効です。" },
        { code: "429", message: "アプリのリクエスト回数上限を超えました。" },
        { code: "500", message: "サーバ内部でエラーが発生しました。" },
        { code: "502", message: "ゲートウェイが不正です。プロキシサーバのエラーです。" },
        { code: "503", message: "メンテナンス中です。アプリは利用できません。" }
      res_status = statuses.select { |status| status[:code] == response.code }
      res_status[0]
    end

    def twitter_client(login_user)
      Twitter::REST::Client.new do |config|
        config.consumer_key = ENV["TWITTER_API_KEY"]
        config.consumer_secret = ENV["TWITTER_API_SECRET"]
        config.access_token = login_user.token
        config.access_token_secret = login_user.secret
      end
    end
  end
end
