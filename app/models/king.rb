class King < Piece
  def valid_move?(destination_x, destination_y)
    return false if destination_y > 7 || destination_x > 7 || destination_y < 0 || destination_x < 0
    destination_piece = game.pieces.find_by(column_coordinate: destination_x, row_coordinate: destination_y, is_on_board?: true)
    return false if destination_piece.present? && destination_piece.color == color
    return true if vertical_move?(destination_x) && (row_coordinate - destination_y).abs == 1 ||
                   horizontal_move?(destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_up_and_left_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_down_and_left_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_up_and_right_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_down_and_right_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1
    false
  end
end
