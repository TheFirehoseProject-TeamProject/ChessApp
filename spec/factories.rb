FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password 'secretPassword'
    password_confirmation 'secretPassword'
  end

  factory :piece do

    column_coordinate 4
    row_coordinate 4
  end

  factory :game do
  end
end
