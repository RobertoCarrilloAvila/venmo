FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@venmo.com" }
    name             { Faker::Name.first_name }
    last_name        { Faker::Name.last_name }
  end
end