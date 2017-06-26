class King < Piece
  def valid_move?(destination_x, destination_y)
    return false if next_to_other_king?(destination_x, destination_y)
    return true if vertical_move?(destination_x) && (row_coordinate - destination_y).abs == 1 ||
                   horizontal_move?(destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_up_and_left_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_down_and_left_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_up_and_right_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_down_and_right_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1
    false
  end

  def next_to_other_king?(destination_x, destination_y)
    other_king = color == 'white' ? game.pieces.find_by(type: 'King', color: 'black') : game.pieces.find_by(type: 'King', color: 'white')
    return true if (other_king.row_coordinate == destination_y) && (other_king.column_coordinate - destination_x).abs == 1
    return true if (other_king.row_coordinate - destination_y).abs == 1 && (other_king.column_coordinate == destination_x)
    false
  end
end
