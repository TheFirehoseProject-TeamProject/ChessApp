class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

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
end
