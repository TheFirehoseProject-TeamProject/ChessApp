class Pawn < Piece
  def valid_move?(destination_x, destination_y)
    return true if vertical_move?(destination_x) && (destination_y - row_coordinate) == 1 && color == 'black'
    return true if vertical_move?(destination_x) && (row_coordinate - destination_y) == 1 && color == 'white'
    return true if vertical_move?(destination_x) && row_coordinate == 6 && (row_coordinate - destination_y) == 2 && color == 'white'
    return true if vertical_move?(destination_x) && row_coordinate == 1 && (destination_y - row_coordinate) == 2 && color == 'black'
    false
  end
end
