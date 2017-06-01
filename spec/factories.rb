 
FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password "secretPassword"
    password_confirmation "secretPassword"
    # game_id 1
  end

  factory :piece do
    user_id 1
    game_id 1
    association :game
  end

  factory :game do
    name 'game'
    id 1
    number_of_moves 0
    game_status 0
    black_player_id 1
    white_player_id 2
    association :user
  end
 
end


