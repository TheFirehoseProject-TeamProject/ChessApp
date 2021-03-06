class Bishop < Piece
  def valid_move?(destination_x, destination_y)
    return true if diagonal_up_and_left_move?(destination_x, destination_y) ||
                   diagonal_down_and_left_move?(destination_x, destination_y) ||
                   diagonal_up_and_right_move?(destination_x, destination_y) ||
                   diagonal_down_and_right_move?(destination_x, destination_y)
    false
  end
end
