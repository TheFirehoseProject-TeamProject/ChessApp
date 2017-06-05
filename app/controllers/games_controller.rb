class GamesController < ApplicationController
  def create
    @game = Game.create(game_params)
    @game.populate_board!

    redirect_to game_path(@game)
  end

  def show
    @board = draw_board
  end

  def update
  end

  private

  def draw_board
    board = Array.new(8) { Array.new(8) }
    column = (1..8).to_a
    row = (1..8).to_a
    row.each_with_index do |_row, row_index|
      column.each_with_index do |_column, column_index|
        board[row_index][column_index] = if column_index.even? && row_index.even? || row_index.odd? && column_index.odd?
                                           'white_field'
                                         else
                                           'black_field'
                                         end
      end
    end
    board
  end

  def game_params
    params.require(:game).permit(:name, :number_of_moves, :black_player_id, :white_player_id, :game_status)
  end
end

  def game
    @game ||= Game.where(id: params[:id]).last
  end
