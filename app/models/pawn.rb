class Pawn < Piece
  def valid_move?(destination_x, destination_y)
    return true if white_pawn_one_step_move?(destination_x, destination_y) ||
                   white_pawn_two_step_move?(destination_x, destination_y) ||
                   black_pawn_one_step_move?(destination_x, destination_y) ||
                   black_pawn_two_step_move?(destination_x, destination_y) ||
                   white_pawn_diagonal_strike?(destination_x, destination_y) ||
                   black_pawn_diagonal_strike?(destination_x, destination_y)
    false
  end
end

private

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
end

def black_pawn_diagonal_strike?(destination_x, destination_y)
  return true if color == 'black' &&
                 !Piece.where(column_coordinate: destination_x, row_coordinate: destination_y).empty? &&
                 (diagonal_down_and_right_move?(destination_x, destination_y) || diagonal_down_and_left_move?(destination_x, destination_y))
end
