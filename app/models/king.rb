class King < Piece
  def valid_move?(destination_x, destination_y)
    return true if vertical_move?(destination_x) && (row_coordinate - destination_y).abs == 1
    return true if horizontal_move?(destination_y) && (column_coordinate - destination_x).abs == 1
    false
  end
end
