class Game < ApplicationRecord
  has_many :users
  has_many :pieces

  enum game_status: { in_progress: 0, checkmate: 1, stalemate: 2 }
end
