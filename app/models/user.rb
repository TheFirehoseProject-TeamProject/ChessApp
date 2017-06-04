class User < ApplicationRecord
  belongs_to :game
  has_many :pieces

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
