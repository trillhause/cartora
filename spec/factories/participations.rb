FactoryGirl.define do
  factory :participation do
    id { rand(100000) }
    association :user, factory: :user, strategy: :build
    association :event, factory: :event, strategy: :build
    attending "false"
  end
end
