FactoryBot.define do
  factory :user do
    uid { 123_456 }
    nickname { "string" }
    token { "string" }
    secret { "string" }
  end
end
