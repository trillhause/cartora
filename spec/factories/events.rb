FactoryGirl.define do
  factory :event do
    name "Test Event"
    start_time "2016-11-13 13:39:19"
    end_time "2016-11-13 14:50:19"
    association :organiser, factory: :user, strategy: :build
  end
end
