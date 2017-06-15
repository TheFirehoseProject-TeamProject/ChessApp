class Rook < Piece
  def valid_move?(destination_x, destination_y)
    return false if obstructed?(destination_x, destination_y)
    return false if destination_x < 0 || destination_x > 7 || destination_y < 0 || destination_y > 7
    destination_x == x || destination_y == y
  end
end
