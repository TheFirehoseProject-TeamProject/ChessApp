class GamesController < ApplicationController
  before_action :authenticate_user!, only: :show
  helper_method :current_game

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)

    redirect_to game_path(@game.id)
  end

  def show
    @game = current_game
    @game.populate_board! if @game.black_player_id && @game.white_player_id && @game.empty_board?
    @waiting = true if @game.black_player_id.nil? || @game.white_player_id.nil?
    @board = current_board
  end

  def game_available
    return render plain: 'true' if !current_game.white_player_id || !current_game.black_player_id
    render plain: 'false'
  end

  private

  def current_game
    @current_game ||= Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:black_player_id, :white_player_id)
  end
end
