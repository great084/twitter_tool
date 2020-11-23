

class TweetsController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

  def index
    client = twitter_client
    @user = User.first

    #Twitter developerのコード
    uri = URI.parse("https://api.twitter.com/1.1/tweets/search/30day/dev.json")

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{ENV["BEARER_TOKEN"]}"
    request.body = "{
      \"query\":\"from:YUTAJAPAN210\",
      \"maxResults\":\"10\",
      \"fromDate\":\"202010201200\",
      \"toDate\":\"202010262000\"
    }"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    @response = JSON.parse(response.body)
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