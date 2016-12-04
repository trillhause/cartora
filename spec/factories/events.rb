FactoryGirl.define do
  factory :event do
    id { FFaker::PhoneNumber.area_code }
    name { FFaker::Name.name }
    start_time "2016-11-13 13:39:19"
    end_time "2016-11-13 14:50:19"
    association :host, factory: :user, strategy: :build
  end
end
