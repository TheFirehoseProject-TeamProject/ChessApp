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
      board[piece.row_coordinate][piece.column_coordinate][:piece] = piece
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
