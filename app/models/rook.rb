class Rook < Piece
  def valid_move?(destination_x, destination_y)
    vertical_move?(destination_x) || horizontal_move?(destination_y)
    #   return false if obstructed?(destination_x, destination_y)
    #   true
    # end
    # false
  end
end
