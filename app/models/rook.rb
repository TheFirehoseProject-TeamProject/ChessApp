class Rook < Piece
  def valid_move?(destination_x, destination_y)
    destination_x == x || destination_y == y
  end

  def obstructed_squares(destination_x, _destination_y)
    rectilinear_obstruction_array(destination_x, destiantion_y)
  end
end
