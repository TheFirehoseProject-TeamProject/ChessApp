class GamesController < ApplicationController
  def new; end

  def create; end

  def show
    draw_board
  end

  private

  def draw_board
    @board = Array.new(8) { Array.new(8) }
    column = [1, 2, 3, 4, 5, 6, 7, 8]
    row = [1, 2, 3, 4, 5, 6, 7, 8]
    row.each_with_index do |_row, ri|
      column.each_with_index do |_column, ci|
        @board[ri][ci] = if ci.even? && ri.even? || ri % 2 > 0 && ci % 2 > 0
                           'white_field.png'
                         else
                           'black_field.png'
                         end
      end
    end
  end
end
