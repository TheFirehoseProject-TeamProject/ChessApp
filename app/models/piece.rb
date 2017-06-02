class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game

  def self.types
    %w[King Queen Rook Bishop Knight Pawn]
  end

  def obstructed?(destination_x, destination_y)
    raise 'Error: Invalid Input' if destination_y > 7 || destination_x > 7 || destination_y < 0 || destination_x < 0
    destination_tests =
      [
        horizontal?(destination_x, destination_y),
        vertically?(destination_x, destination_y),
        diagonal_up_right_down_left?(destination_x, destination_y),
        diagonal_up_left_down_right?(destination_x, destination_y)
      ]

    if destination_tests.include?(true)
      return true
    else
      false
    end
  end

  def invalid_input?(destination_tests)
    return true if !destination_tests.include?(true) && !destination_tests.include?(false)
  end


  def horizontal?(destination_x, destination_y)
    if destination_x < column_coordinate && destination_y == row_coordinate # checking left
      ((destination_x + 1)..(column_coordinate - 1)).each do |col|
        result = Piece.where(column_coordinate: col, row_coordinate: row_coordinate).present?
        return true if result
      end
      return false
    end
    if destination_x > column_coordinate && destination_y == row_coordinate # checking right
      ((column_coordinate + 1)..(destination_x - 1)).each do |col|
        result = Piece.where(column_coordinate: col, row_coordinate: row_coordinate).present?
        return true if result
      end
      return false
    end
  end

  def vertically?(destination_x, destination_y)
    if destination_y > row_coordinate && destination_x == column_coordinate # checking up
      ((row_coordinate + 1)..(destination_y - 1)).each do |row|
        result = Piece.where(row_coordinate: row, column_coordinate: column_coordinate).present?
        return true if result
      end
      return false
    end
    if destination_y < row_coordinate && destination_x == column_coordinate # checking down
      ((destination_y + 1)..(row_coordinate - 1)).each do |row|
        result = Piece.where(row_coordinate: row, column_coordinate: column_coordinate).present?
        return true if result
      end
      return false
    end
  end

  def diagonal_up_right_down_left?(destination_x, destination_y)
    length1 = (destination_x - destination_y)
    length2 = (column_coordinate - row_coordinate)
    if destination_y > row_coordinate && destination_x > column_coordinate && length1 == length2 # checking up right
      ((row_coordinate + 1)..(destination_y - 1)).each_with_index do |row, index|
        index += 1
        result = Piece.where(row_coordinate: row, column_coordinate: column_coordinate + index).present?
        return true if result
      end
      return false
    end
    if destination_y < row_coordinate && destination_x < column_coordinate && length1 == length2 # checking down left
      ((destination_y + 1)..(row_coordinate - 1)).each_with_index do |row, index|
        index += 1
        result = Piece.where(row_coordinate: row, column_coordinate: column_coordinate - index).present?
        return true if result
      end
      return false
    end
  end

  def diagonal_up_left_down_right?(destination_x, destination_y)
    length1 = (column_coordinate - destination_x)
    length2 = (destination_y - row_coordinate)
    if destination_y > row_coordinate && destination_x < column_coordinate && length1 == length2 # checking up left
      ((row_coordinate + 1)..(destination_y - 1)).each_with_index do |row, index|
        index += 1
        result = Piece.where(row_coordinate: row, column_coordinate: column_coordinate - index).present?
        return true if result
      end
      return false
    end
    if destination_y < row_coordinate && destination_x > column_coordinate && length1 == length2 # checking down right
      ((destination_y + 1)..(row_coordinate - 1)).to_a.reverse.each_with_index do |row, index|
        index += 1
        result = Piece.where(row_coordinate: row, column_coordinate: column_coordinate + index).present?
        return true if result
      end
      return false
    end
  end
end
