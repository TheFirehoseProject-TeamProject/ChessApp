class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

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
end
