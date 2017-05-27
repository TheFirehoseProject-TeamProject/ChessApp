class AddDetailsToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :number_of_moves, :integer
    add_column :games, :white_player_id, :integer
    add_column :games, :black_player_id, :integer
    add_column :games, :game_status, :integer
  end
end
