namespace :heroku_auto do
  require "#{pwd}/app/lib/twitter_api"
  require "#{pwd}/app/lib/automation"
  include TwitterApi
  include Automation

  desc "自動投稿するタスク"
  task tweet: :environment do
    @user = User.find(1)
    auto_tweet(@user)
  end
end
