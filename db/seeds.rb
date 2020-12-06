User.find_or_create_by!(nickname: "test") do |user|
  uid:"123456789",
  nickname:"test"
end
@user=User.find_by(nickname: "test")

10.times do |n|
  Tweet.create!(
    tweet_created_at: "Sat, 21 Nov 2020 02:28:09 UTC +00:00",
    tweet_id:"123456789",
    text: "こんにちは#{n + 1}",
    retweet_count: n+1,
    favorite_count: n+1,
    user_id: @user.id,
    tweet_flag: true,
    retweet_flag: false
  )
  end

# 10.times do |n|
#   Medium.create!(
#     tweet_id: n+1,
#     media_url: File.open('./app/assets/images/sample.png')
#   )
# end 