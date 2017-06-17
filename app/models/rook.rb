class Rook < Piece
  def valid_move?(destination_x, destination_y)
    if obstructed?(destination_x, destination_y)
      return false
    if vertical_move?(destination_x) || horizontal_move?(destination_y)
      return true
    end
    false
  end
end
