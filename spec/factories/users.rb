FactoryBot.define do
  factory :user do
    uid { 123_456 }
    nickname { Faker::Name.first_name }
  end
end
