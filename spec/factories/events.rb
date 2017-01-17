FactoryGirl.define do
  factory :event do
    id { rand(1000000) }
    name { FFaker::Name.name }
    start_time "2016-11-13 13:39:19"
    end_time "2016-11-13 14:50:19"
    association :host, factory: :user, strategy: :build

    after(:create) do |event|
      create(:location, area: event)
    end
  end

  factory :event_with_participants, parent: :event do
    users {[FactoryGirl.create(:user)]}
  end
end
