FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.characters(number: 20)}
    score { 0.0 }
    user
    event
  end
end
