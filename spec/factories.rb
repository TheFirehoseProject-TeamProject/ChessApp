
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
    name 'game'
    game_status 0
    black_player_id 1
    white_player_id 2
    association :user
  end
 
end


