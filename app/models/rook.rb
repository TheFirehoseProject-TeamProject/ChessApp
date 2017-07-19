class Rook < Piece
  def valid_move?(destination_x, destination_y)
    return false if not_moved?(destination_x, destination_y)
    return true if vertical_move?(destination_x) || horizontal_move?(destination_y)
    false
  end
end
