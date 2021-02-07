FactoryBot.define do
  factory :auto_tweet do
    user_uid { "MyString" }
    tweet_hour1 { 1 }
    tweet_hour2 { 1 }
    tweet_hour3 { 1 }
    tweet_hour4 { 1 }
    tweet_hour5 { 1 }
    sort_column { "MyString" }
    order { "MyString" }
    exclude_tweet { 1 }
    exclude_retweet { 1 }
    count { 1 }
  end
end
