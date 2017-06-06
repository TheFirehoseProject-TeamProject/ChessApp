class GamesController < ApplicationController
  def create
    @game = Game.create(game_params)
    @game.populate_board!

    redirect_to game_path(@game)
  end

  def show
    @board = draw_board
  end

  private


  def game_params
    params.require(:game).permit(:name, :number_of_moves, :black_player_id, :white_player_id, :game_status)
  end
end
