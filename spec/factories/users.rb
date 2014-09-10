FactoryGirl.define do
  factory :user do
    first_name "Spaceman"
    last_name "Spiff"
    sequence( :email ) { |n| "smanspiff#{n}@example.com" }
    password "password"
    password_confirmation "password"
  end
end