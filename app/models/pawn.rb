class Pawn < Piece
  def valid_move?(destination_x, destination_y)
    return true if vertical_move?(destination_x) && (destination_y - row_coordinate) == 1 && color == 'white'
    return true if vertical_move?(destination_x) && (row_coordinate - destination_y) == 1 && color == 'black'
    return true if vertical_move?(destination_x) && row_coordinate == 6 && (row_coordinate - destination_y) == 2 && color == 'black'
    return true if vertical_move?(destination_x) && row_coordinate == 1 && (destination_y - row_coordinate) == 2 && color == 'white'
    if color == 'white' && !Piece.where(column_coordinate: destination_x, row_coordinate: destination_y).empty?
      return true if diagonal_up_and_right_move?(destination_x, destination_y) || diagonal_up_and_left_move?(destination_x, destination_y)
    elsif color == 'black' && !Piece.where(column_coordinate: destination_x, row_coordinate: destination_y).empty?
      return true if diagonal_down_and_right_move?(destination_x, destination_y) || diagonal_down_and_left_move?(destination_x, destination_y)
    end
    false
  end
end
