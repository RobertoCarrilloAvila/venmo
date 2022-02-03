FactoryBot.define do
  factory :user do
    email     { Faker::Internet.email }
    name      { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    balance   { 0 }
  end
end