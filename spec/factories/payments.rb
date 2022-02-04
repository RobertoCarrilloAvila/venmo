FactoryBot.define do
  factory :payment do
    origin      factory: :user
    target      factory: :user
    amount      { rand(100..500) }
    description { Faker::Lorem.sentence }
  end
end
