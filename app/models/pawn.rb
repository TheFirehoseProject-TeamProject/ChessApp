class Pawn < Piece
  def valid_move?(destination_x, destination_y)
    blocking_piece = game.pieces.where(row_coordinate: destination_y, column_coordinate: destination_x, is_on_board?: true).present?
    return true if (white_pawn_one_step_move?(destination_x, destination_y) ||
                    white_pawn_two_step_move?(destination_x, destination_y) ||
                    black_pawn_one_step_move?(destination_x, destination_y) ||
                    black_pawn_two_step_move?(destination_x, destination_y)
                   ) && !blocking_piece ||
                   white_pawn_diagonal_strike?(destination_x, destination_y) ||
                   en_passant_move?(destination_x, destination_y) ||
                   black_pawn_diagonal_strike?(destination_x, destination_y)
    false
  end
end

private

def en_passant_situation?(destination_x, destination_y)
  if row_coordinate == 1 && white_pawn_two_step_move?(destination_x, destination_y)
    return true if pawn_left_or_right_of_destination?(destination_x, destination_y)
  elsif row_coordinate == 6 && black_pawn_two_step_move?(destination_x, destination_y)
    return true if pawn_left_or_right_of_destination?(destination_x, destination_y)
  end
  false
end

def find_en_passant_pawn_to_capture(destination_x, destination_y)
  return game.pieces.find_by(row_coordinate: destination_y - 1, column_coordinate: destination_x) if color == 'white'
  return game.pieces.find_by(row_coordinate: destination_y + 1, column_coordinate: destination_x) if color == 'black'
end

def pawn_left_or_right_of_destination?(destination_x, destination_y)
  return true if game.pieces.find_by(row_coordinate: destination_y, column_coordinate: destination_x - 1, type: 'Pawn', color: 'black').present? && color == 'white'
  return true if game.pieces.find_by(row_coordinate: destination_y, column_coordinate: destination_x + 1, type: 'Pawn', color: 'black').present? && color == 'white'
  return true if game.pieces.find_by(row_coordinate: destination_y, column_coordinate: destination_x - 1, type: 'Pawn', color: 'white').present? && color == 'black'
  return true if game.pieces.find_by(row_coordinate: destination_y, column_coordinate: destination_x + 1, type: 'Pawn', color: 'white').present? && color == 'black'
  false
end

def en_passant_move?(destination_x, destination_y)
  return false if game.piece_capturable_by_en_passant.blank?
  return false if Piece.find(game.piece_capturable_by_en_passant).column_coordinate != destination_x

  return true if color == 'white' && (diagonal_up_and_right_move?(destination_x, destination_y) ||
                                      diagonal_up_and_left_move?(destination_x, destination_y))
  return true if color == 'black' && (diagonal_down_and_right_move?(destination_x, destination_y) ||
                                      diagonal_down_and_left_move?(destination_x, destination_y))
  false
end

def white_pawn_one_step_move?(destination_x, destination_y)
  vertical_move?(destination_x) && (destination_y - row_coordinate) == 1 && color == 'white'
end

def white_pawn_two_step_move?(destination_x, destination_y)
  vertical_move?(destination_x) && row_coordinate == 1 && (destination_y - row_coordinate) == 2 && color == 'white'
end

def black_pawn_one_step_move?(destination_x, destination_y)
  vertical_move?(destination_x) && (row_coordinate - destination_y) == 1 && color == 'black'
end

def black_pawn_two_step_move?(destination_x, destination_y)
  vertical_move?(destination_x) && row_coordinate == 6 && (row_coordinate - destination_y) == 2 && color == 'black'
end

def white_pawn_diagonal_strike?(destination_x, destination_y)
  return true if color == 'white' &&
                 game.pieces.where(column_coordinate: destination_x, row_coordinate: destination_y).present? &&
                 (diagonal_up_and_right_move?(destination_x, destination_y) || diagonal_up_and_left_move?(destination_x, destination_y)) &&
                 (destination_y - row_coordinate) == 1
  false
end

def black_pawn_diagonal_strike?(destination_x, destination_y)
  return true if color == 'black' &&
                 game.pieces.where(column_coordinate: destination_x, row_coordinate: destination_y).present? &&
                 (diagonal_down_and_right_move?(destination_x, destination_y) || diagonal_down_and_left_move?(destination_x, destination_y)) &&
                 (row_coordinate - destination_y) == 1
  false
end
