

class TweetsController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

  def index
    client = twitter_client
    @user = User.first

    # @tweets = client.home_timeline
    # #API用のURLを設定（●にはデベロッパー管理画面のDev environment labelを入力）
    # uri = "https://api.twitter.com/1.1/tweets/search/30day/dev.json"
    # #uri = URI.parse("https://api.twitter.com/1.1/search/tweets.json")

    # #paramsに検索ワードや件数、日付などを入力
    # params = {
    #   query: '純情エビデンス', #検索したいワード
    #   maxResults: 10,  #取得件数
    # }.to_json
    #res = RestClient.post uri, params, { :Authorization => "#{client}", content_type: :json }
    #@res = client.search("純情エビデンス", count: 10, result_type: "recent",  exclude: "retweets", since_id: nil)

    #上記で設定したパラメーターをget関数を使い指定URLから取得
    #@res = client.get(uri, params)

    #Twitter developerのコード
    uri = URI.parse("https://api.twitter.com/1.1/tweets/search/30day/dev.json")

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{ENV["BEARER_TOKEN"]}"
    request.body = "{
      \"query\":\"from:YUTAJAPAN210\",
      \"maxResults\":\"50\",
      \"fromDate\":\"202010161200\",
      \"toDate\":\"202010161300\"
    }"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    @res = JSON.parse(response.body)
    binding.pry
  end

  def twitter_client
    return client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TWITTER_API_KEY"]
      config.consumer_secret = ENV["TWITTER_API_SECRET"]
      config.access_token = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
  end
end