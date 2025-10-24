FactoryBot.define do
  factory :event do
    name { Faker::Lorem.characters(number: 10) }
    introduction { Faker::Lorem.characters(number: 20) }
    date { Faker::Date.in_date_period(month: (Time.current.month + 1)) }
    start_time { '13:00' }
    end_time { '18:00' }
    venue { 'XX県XX市XX町XX-XX-XX' }
    min_people { 4 }
    max_people { 8 }
    user
    
    after(:build) do |event|
      event.event_image.attach(io: File.open('spec/images/no_event_image.jpg'), filename: 'event_image.jpg', content_type: 'application/xlsx')
    end
  end
end
