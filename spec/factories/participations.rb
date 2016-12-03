FactoryGirl.define do
  factory :participation do
    id { FFaker::PhoneNumber.area_code }
    association :user, factory: :user, strategy: :build
    association :event, factory: :event, strategy: :build
    attending "false"
  end
end
