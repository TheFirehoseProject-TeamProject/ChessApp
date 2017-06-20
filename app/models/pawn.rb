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

def en_passant_situation?
  if row_coordinate == 4 && color == 'white'
    return true if en_passant_piece.present?
  elsif row_coordinate == 3 && color == 'black'
    return true if en_passant_piece.present?
  end
  false
end

def en_passant_piece
  en_passant_piece = []
  if row_coordinate == 4 && color == 'white'
    if game.pieces.find_by(row_coordinate: row_coordinate, column_coordinate: column_coordinate - 1, type: 'Pawn', color: 'black').present?
      en_passant_piece << game.pieces.find_by(row_coordinate: row_coordinate, column_coordinate: column_coordinate - 1, type: 'Pawn', color: 'black')
    elsif game.pieces.find_by(row_coordinate: row_coordinate, column_coordinate: column_coordinate + 1, type: 'Pawn', color: 'black').present?
      en_passant_piece << game.pieces.find_by(row_coordinate: row_coordinate, column_coordinate: column_coordinate + 1, type: 'Pawn', color: 'black')
    end
  elsif row_coordinate == 3 && color == 'black'
    if game.pieces.find_by(row_coordinate: row_coordinate, column_coordinate: column_coordinate - 1, type: 'Pawn', color: 'white').present?
      en_passant_piece << game.pieces.find_by(row_coordinate: row_coordinate, column_coordinate: column_coordinate - 1, type: 'Pawn', color: 'white')
    elsif game.pieces.find_by(row_coordinate: row_coordinate, column_coordinate: column_coordinate + 1, type: 'Pawn', color: 'white').present?
      en_passant_piece << game.pieces.find_by(row_coordinate: row_coordinate, column_coordinate: column_coordinate + 1, type: 'Pawn', color: 'white')
    end
    en_passant_piece
  end
end

def en_passant_move?(destination_x, destination_y)
  if en_passant_situation?
    return true if color == 'white' && (diagonal_up_and_right_move?(destination_x, destination_y) ||
                                       diagonal_up_and_left_move?(destination_x, destination_y))
    return true if color == 'black' && (diagonal_down_and_right_move?(destination_x, destination_y) ||
                                      diagonal_down_and_left_move?(destination_x, destination_y))
  end
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
                 !Piece.where(column_coordinate: destination_x, row_coordinate: destination_y).empty? &&
                 (diagonal_up_and_right_move?(destination_x, destination_y) || diagonal_up_and_left_move?(destination_x, destination_y))
  false
end

def black_pawn_diagonal_strike?(destination_x, destination_y)
  return true if color == 'black' &&
                 !Piece.where(column_coordinate: destination_x, row_coordinate: destination_y).empty? &&
                 (diagonal_down_and_right_move?(destination_x, destination_y) || diagonal_down_and_left_move?(destination_x, destination_y))
  false
end
