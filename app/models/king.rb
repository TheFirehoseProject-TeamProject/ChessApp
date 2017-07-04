class King < Piece
  def valid_move?(destination_x, destination_y)
    return false if destination_y > 7 || destination_x > 7 || destination_y < 0 || destination_x < 0
    destination_piece = game.pieces.find_by(column_coordinate: destination_x, row_coordinate: destination_y, is_on_board?: true)
    return false if destination_piece.present? && destination_piece.color == color
    return true if vertical_move?(destination_x) && (row_coordinate - destination_y).abs == 1 ||
                   horizontal_move?(destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_up_and_left_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_down_and_left_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_up_and_right_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1 ||
                   diagonal_down_and_right_move?(destination_x, destination_y) && (column_coordinate - destination_x).abs == 1
    return true if destination_x == 2 && destination_y.zero? && color == 'white' && moved? == false ||
                   destination_x == 6 && destination_y.zero? && color == 'white' && moved? == false ||
                   destination_x == 2 && destination_y == 7 && color == 'black' && moved? == false ||
                   destination_x == 6 && destination_y == 7 && color == 'black' && moved? == false
    false
  end

  def move_to!(destination_x, destination_y)
    if destination_x == 6 && destination_y.zero? && moved? == false
      castle!(7, 0) if castle?(7, 0)
    elsif destination_x == 2 && destination_y.zero? && moved? == false
      castle!(0, 0) if castle?(0, 0)
    elsif destination_x == 6 && destination_y == 7 && moved? == false
      castle!(7, 7) if castle?(7, 7)
    elsif destination_x == 2 && destination_y == 7 && moved? == false
      castle!(0, 7) if castle?(0, 7)
    else
      super
    end
  end

  def castle!(rook_column_coordinate, rook_row_coordinate)
    rook = game.pieces.find_by(column_coordinate: rook_column_coordinate, row_coordinate: rook_row_coordinate)
    raise 'Invalid move' unless castle?(rook_column_coordinate, rook_row_coordinate)
    if rook_column_coordinate == 7
      update(column_coordinate: column_coordinate + 2)
      rook.update(column_coordinate: rook_column_coordinate - 2)
      reload
    elsif rook_column_coordinate.zero?
      update(column_coordinate: column_coordinate - 2)
      rook.update(column_coordinate: rook_column_coordinate + 3)
      reload
    end
  end

  def castle?(rook_column_coordinate, rook_row_coordinate)
    rook = game.pieces.find_by(column_coordinate: rook_column_coordinate, row_coordinate: rook_row_coordinate, type: 'Rook')
    return false if moved?
    return false if rook.nil? || rook.moved?
    return false if obstructed?(rook_column_coordinate, rook_row_coordinate)
    return false if game.check?
    if rook_column_coordinate == 7
      while column_coordinate < rook_column_coordinate - 1
        update(column_coordinate: column_coordinate + 1)
        reload
        if game.check?
          update(column_coordinate: 4)
          return false
        end
      end
      update(column_coordinate: 4)
    end
    if rook_column_coordinate.zero?
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

  # can get removed once not_move_into_check method is implemented
  def next_to_other_king?(destination_x, destination_y)
    other_king = color == 'white' ? game.pieces.find_by(type: 'King', color: 'black') : game.pieces.find_by(type: 'King', color: 'white')
    return true if (other_king.row_coordinate == destination_y) && (other_king.column_coordinate - destination_x).abs == 1
    return true if (other_king.row_coordinate - destination_y).abs == 1 && (other_king.column_coordinate == destination_x)
    return true if (other_king.row_coordinate - destination_y).abs == 1 && (other_king.column_coordinate - destination_x).abs == 1
    false
  end
end
