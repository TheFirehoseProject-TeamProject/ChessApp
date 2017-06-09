class GamesController < ApplicationController
  helper_method :current_game

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    @game.populate_board!

    redirect_to game_path(@game.id)
  end

  def show
    @board = current_board
  end

  private

  def current_game
    @current_game ||= Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:black_player_id, :white_player_id)
  end
end
