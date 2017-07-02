class AddDefaultTurnToGames < ActiveRecord::Migration[5.0]
  def change
    change_column_default :games, :turn, Game.white_player_id
  end
end
