FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password 'secretPassword'
    password_confirmation 'secretPassword'

    association :game
  end

  factory :piece do
    association :game
    association :user

    trait :is_on_board do
      is_on_board? true
      column_coordinate 4
      row_coordinate 4
    end

    trait :is_off_board do
      is_on_board? false
    end
  end

  factory :game do
  end
end
