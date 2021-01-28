FactoryBot.define do
  factory :medium do
    association :tweet
    media_url { "string" }
  end
end