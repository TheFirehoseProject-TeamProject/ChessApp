class King < Piece
  def valid_move?(destination_x, destination_y)
    return true if vertical_move?(destination_x) && (row_coordinate - destination_y).abs == 1 ||
                   horizontal_move?(destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_up_and_left_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_down_and_left_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_up_and_right_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_down_and_right_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1
    false
  end

  def castle!(rook_column_coordinate, rook_row_coordinate)
    rook = game.pieces.find_by(column_coordinate: rook_column_coordinate, row_coordinate: rook_row_coordinate)
    if castle?(rook_column_coordinate, rook_row_coordinate)
      if rook_column_coordinate == 7
        update(column_coordinate: column_coordinate + 2)
        rook.update(column_coordinate: rook_column_coordinate - 2)
      elsif rook_column_coordinate == 0
        update(column_coordinate: column_coordinate - 2)
        rook.update(column_coordinate: rook_column_coordinate + 3)
      end
    else
      raise 'Invalid move'
    end
  end

  def castle?(rook_column_coordinate, rook_row_coordinate)
    rook = game.pieces.find_by(column_coordinate: rook_column_coordinate, row_coordinate: rook_row_coordinate)
    return false if updated_at != created_at
    return false if rook.updated_at != rook.created_at
    return false if obstructed?(rook_column_coordinate, rook_row_coordinate)
    return false if game.check?
    if rook_column_coordinate == 7
      while column_coordinate < rook_column_coordinate - 1
        update(column_coordinate: column_coordinate + 1)
        if game.check?
          update(column_coordinate: 4)
          return false
        end
      end
      update(column_coordinate: 4)
    end
    if rook_column_coordinate == 0
      while column_coordinate > rook_column_coordinate + 2
        update(column_coordinate: column_coordinate - 1)
        if game.check?
          update(column_coordinate: 4)
          return false
        end
      end
      update(column_coordinate: 4)
    end
    true
  end
end
