class TwitterApi
  class << self
    def fetch_tweet(query_params)
      uri = URI.parse("https://api.twitter.com/1.1/tweets/search/#{ENV['PLAN']}/#{ENV['LABEL']}.json")
      headers = fetch_headers
      http = http_settings(uri)
      request = Net::HTTP::Post.new(uri.request_uri, headers)
      request.body = sent_query(query_params)
      http.request(request)
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

    def sent_query(query_params)
      data = {
        "query": "from:#{query_params[:login_user]}".to_s,
        "fromDate": query_params[:date_from].to_s,
        "toDate": query_params[:date_to].to_s
      }
      data.merge!({ "next": query_params[:next].to_s }) if query_params[:next]
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
  end
end
