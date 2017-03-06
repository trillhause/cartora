FactoryGirl.define do
  factory :user do
    id { rand(100000) }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    email { FFaker::Internet.email }
    password "12345678"
    password_confirmation "12345678"
    fcm_id "Ju5tATe5T1D"

    after(:create) do |user|
      create(:location, area: user)
    end
  end
end
