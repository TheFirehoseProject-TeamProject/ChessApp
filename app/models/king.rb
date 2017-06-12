class King < Piece
  def valid_move?(destination_x, destination_y)
    return true if vertical_move?(destination_x) && (row_coordinate - destination_y).abs == 1 ||
                   horizontal_move?(destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_up_and_left_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_down_and_left_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_up_and_right_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_down_and_right_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1
    false
  end
end
