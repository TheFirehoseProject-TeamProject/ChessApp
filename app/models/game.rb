class Game < ApplicationRecord
  has_many :users
  has_many :pieces

  # belongs_to :white_player, class_name: 'User'
  # belongs_to :black_player, class_name: 'User'

  enum game_status: { in_progress: 0, checkmate: 1, stalemate: 2 }
end
