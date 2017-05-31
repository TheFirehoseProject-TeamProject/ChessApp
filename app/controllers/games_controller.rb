class GamesController < ApplicationController
  def new; end


  def create
    @game = Game.create(game_params)
    @game.populate_board!

    redirect_to game_path(@game)
  end

  def create; end


  def show
    @board = draw_board
  end

  private

  def draw_board
    board = Array.new(8) { Array.new(8) }
    column = (1..8).to_a
    row = (1..8).to_a
    row.each_with_index do |_row, row_index|
      column.each_with_index do |_column, column_index|
        if column_index.even? && row_index.even? || row_index.odd? && column_index.odd?
          board[row_index][column_index] = 'white_field'
        else
          board[row_index][column_index] = 'black_field'
        end
      end
    end
    return board
  end


end
