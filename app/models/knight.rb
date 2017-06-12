class Knight < Piece
  def valid_move?(destination_x, destination_y)
    # return true if up_one_right_two(destination_x, destination_y)
    #
    # return true if up_two_right_one(destination_x, destination_y)
    #
    # return true if up_one_left_two(destination_x, destination_y)
    #
    # return true if up_two_left_one(destination_x, destination_y)
    #
    # return true if down_one_left_two(destination_x, destination_y)
    #
    # return true if down_two_left_one(destination_x, destination_y)
    #
    # return true if down_two_right_one(destination_x, destination_y)
    #
    # return true if down_one_right_two(destination_x, destination_y)

    case
    when up_one_right_two(destination_x, destination_y)
      true
    when up_two_right_one(destination_x, destination_y)
      true
    when up_one_left_two(destination_x, destination_y)
      true
    when up_two_left_one(destination_x, destination_y)
      true
    when down_one_left_two(destination_x, destination_y)
      true
    when down_two_left_one(destination_x, destination_y)
      true
    when down_two_right_one(destination_x, destination_y)
      true
    when down_one_right_two(destination_x, destination_y)
      true
    else
      false
    end
  end

  private

  def up_one_right_two(destination_x, destination_y)
    return true if destination_x == column_coordinate + 2 && destination_y == row_coordinate + 1
  end

  def up_two_right_one(destination_x, destination_y)
    return true if destination_x == column_coordinate + 1 && destination_y == row_coordinate + 2
  end

  def up_one_left_two(destination_x, destination_y)
    return true if destination_x == column_coordinate - 2 && destination_y == row_coordinate + 1
  end

  def up_two_left_one(destination_x, destination_y)
    return true if destination_x == column_coordinate - 1 && destination_y == row_coordinate + 2
  end

  def down_two_left_one(destination_x, destination_y)
    return true if destination_x == column_coordinate - 1 && destination_y == row_coordinate - 2
  end

  def down_one_left_two(destination_x, destination_y)
    return true if destination_x == column_coordinate - 2 && destination_y == row_coordinate - 1
  end

  def down_one_right_two(destination_x, destination_y)
    return true if destination_x == column_coordinate + 2 && destination_y == row_coordinate - 1
  end

  def down_two_right_one(destination_x, destination_y)
    return true if destination_x == column_coordinate + 1 && destination_y == row_coordinate - 2
  end
end
