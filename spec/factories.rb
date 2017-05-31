
FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password "secretPassword"
    password_confirmation "secretPassword"

  end

  factory :piece do
    association :game
  end

  factory :game do
    association :user
  end
 
end


