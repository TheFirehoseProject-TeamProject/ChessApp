 
FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "dummy_Email#{n}@gmail.com"
    end
    password "secretPassword"
    password_confirmation "secretPassword"
  end

  factory :piece do
    association :game
    association :user
  end

  factory :game do
    number_of_moves 0
    game_status 0
    association :black_player, factory: :user
    association :white_player, factory: :user
  end
 
end


