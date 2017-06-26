class GamesController < ApplicationController

  before_action :authenticate_user!, only: %i[show new]

  before_action :authenticate_user!, only: %i[show create]

  helper_method :current_game

  def new; end

  def create
    
    redirect_to game_path(@game.id)
  end

  def show
    @game = current_game
    @game.update(black_player_id: current_user.id) if current_user.id != @game.white_player_id
    @game.populate_board! if @game.black_player_id && @game.white_player_id && @game.empty_board?
    @waiting = true if @game.black_player_id.nil? || @game.white_player_id.nil?
    @board = current_board
  end

  def game_available
    return render plain: 'true' if !current_game.white_player_id || !current_game.black_player_id
    render plain: 'false'
  end

  def update
    @game = Game.find(params[:id])
  end

  private

  def current_board
    pieces = current_game.pieces
    board = Array.new(8) { Array.new(8) { { piece: nil } } }
    (0..7).each do |row_index|
      (0..7).each do |column_index|
        board[row_index][column_index] = if column_index.even? && row_index.even? || row_index.odd? && column_index.odd?
                                           { class: 'white_field' }
                                         else
                                           { class: 'black_field' }
                                         end
      end
    end

    pieces.each do |piece|
      board[piece.row_coordinate][piece.column_coordinate][:piece] = piece if piece.is_on_board?
    end

    board
  end

  def current_game
    @current_game ||= Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:black_player_id, :white_player_id)
  end
end
