# User.find_or_create_by!(nickname: "test") do |user|
#   uid:"123456789",
#   nickname:"test"
# end


# 3.times do |n|
#   Tweet.create!(
#     tweet_created_at: "Sat, 21 Nov 2019 02:28:09 UTC +00:00",
#     tweet_string_id:"123456789",
#     text: "こんにちは#{n + 1}",
#     retweet_count: n+1,
#     favorite_count: n+1,
#     user_id:2,
#     tweet_flag: true,
#     retweet_flag: false
#   )
#   end



# 10.times do |n|
#   Medium.create!(
#     tweet_string_id: n+1,
#     media_url: File.open('./app/assets/images/sample.png')
#   )
# end 

  AutoTweet.create!(
    user_id:3,
    tweet_hour1:22,
    tweet_hour2:23,
    tweet_hour3:0,
    tweet_hour4:1,
    tweet_hour5:2,
    sort_column:"retweet_count",
    order:"desc",
    exclude_tweet:1,
    exclude_repost:1,
    count:1,
  )