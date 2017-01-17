FactoryGirl.define do
  factory :location do
    lat { FFaker::Geolocation.lat }
    lng { FFaker::Geolocation.lng }
    association :area
  end
end