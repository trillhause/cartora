FactoryGirl.define do
  factory :event do
    id { rand(1000000) }
    name { FFaker::Name.name }
    start_time { 1480550400 + rand(86400) }
    end_time { 1483228800 + rand(86400) }
    association :host, factory: :user, strategy: :build

    after(:create) do |event|
      create(:location, area: event)
    end
  end

  factory :event_with_participants, parent: :event do
    users {[FactoryGirl.create(:user)]}
  end
end
