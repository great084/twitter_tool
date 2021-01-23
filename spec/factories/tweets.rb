FactoryBot.define do
  factory :tweet do
    association :user
    tweet_created_at { Time.zone.now }
    tweet_string_id { "123456" }
    text { "string" }
    retweet_count { 123 }
    favorite_count { 456 }
    tweet_flag { false }
    retweet_flag { false }
  end
end
