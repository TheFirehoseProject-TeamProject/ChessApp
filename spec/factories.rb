FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password 'secretPassword'
    password_confirmation 'secretPassword'
    id 1
    game_id 1
  end

  factory :piece do
    game_id 1
    user_id 1
    column_coordinate 4
    row_coordinate 4
  end

  factory :game do
    id 1
  end
end
