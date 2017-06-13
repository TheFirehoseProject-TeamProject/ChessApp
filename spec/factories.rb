
FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password 'secretPassword'
    password_confirmation 'secretPassword'
  end

  factory :piece do
    association :game
    association :user

    trait :is_on_board_black do
      is_on_board? true
      column_coordinate 4
      row_coordinate 4
      color 'black'
    end

    trait :is_on_board_white do
      is_on_board? true
      column_coordinate 3
      row_coordinate 5
      color 'white'
    end

    trait :is_off_board do
      is_on_board? false
    end
  end

  factory :game do
    association :black_player, factory: :user
    association :white_player, factory: :user
    number_of_moves 0
    game_status 0
  end

  factory :king do
    association :game
    association :user
    trait :is_on_board do
      is_on_board? true
      column_coordinate 4
      row_coordinate 4
    end
  end

  factory :pawn do
    association :game
    association :user
    trait :is_on_board do
      is_on_board? true
      column_coordinate 1
      row_coordinate 6
    end
  end

  factory :bishop do
    association :game
    association :user
    trait :is_on_board do
      is_on_board? true
      column_coordinate 3
      row_coordinate 3
    end
  end
end
