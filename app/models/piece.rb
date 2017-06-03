
class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game

  def self.types
    %w[King Queen Rook Bishop Knight Pawn]
  end

  def obstructed?(destination_x, destination_y)
    raise 'Error: Invalid Input' if destination_y > 7 || destination_x > 7 || destination_y < 0 || destination_x < 0

    invalid_move_tests =
      [
        horizontal_move?(destination_y),
        vertical_move?(destination_x),
        diagonal_up_and_right_move?(destination_x, destination_y),
        diagonal_down_and_left_move?(destination_x, destination_y),
        diagonal_up_and_left_move?(destination_x, destination_y),
        diagonal_down_and_right_move?(destination_x, destination_y)
      ]

    raise 'Error: Invalid Input' unless invalid_move_tests.include?(true)

    destination_tests =
      [
        horizontal_obstruction_left?(destination_x, destination_y),
        horizontal_obstruction_right?(destination_x, destination_y),
        vertical_obstruction_up?(destination_x, destination_y),
        vertical_obstruction_down?(destination_x, destination_y),
        diagonal_obstruction_down_left?(destination_x, destination_y),
        diagonal_obstruction_up_right?(destination_x, destination_y),
        diagonal_obstruction_down_right?(destination_x, destination_y),
        diagonal_obstruction_up_left?(destination_x, destination_y)
      ]

    return true if destination_tests.include?(true)
    false
  end

  def horizontal_move?(destination_y)
    return true if destination_y == row_coordinate
    false
  end

  def vertical_move?(destination_x)
    return true if destination_x == column_coordinate
  end

  def diagonal_up_and_right_move?(destination_x, destination_y)
    diagonal_move_check_destination_up_and_right = destination_x - destination_y
    diagonal_move_check_origin_up_and_right = column_coordinate - row_coordinate
    return true if diagonal_move_check_destination_up_and_right == diagonal_move_check_origin_up_and_right
    false
  end

  def diagonal_down_and_left_move?(destination_x, destination_y)
    diagonal_move_check_destination_down_and_left = destination_x - destination_y
    diagonal_move_check_origin_down_and_left = column_coordinate - row_coordinate
    return true if diagonal_move_check_destination_down_and_left == diagonal_move_check_origin_down_and_left
    false
  end

  def diagonal_up_and_left_move?(destination_x, destination_y)
    diagonal_move_check_column_up_and_left = column_coordinate - destination_x
    diagonal_move_check_row_up_and_left = destination_y - row_coordinate
    return true if diagonal_move_check_column_up_and_left == diagonal_move_check_row_up_and_left
    false
  end

  def diagonal_down_and_right_move?(destination_x, destination_y)
    diagonal_move_check_column_down_and_right = column_coordinate - destination_x
    diagonal_move_check_row_down_and_right = destination_y - row_coordinate
    return true if diagonal_move_check_column_down_and_right == diagonal_move_check_row_down_and_right
    false
  end

  def horizontal_obstruction_left?(destination_x, destination_y)
    if destination_x < column_coordinate && horizontal_move?(destination_y)
      ((destination_x + 1)..(column_coordinate - 1)).each do |col|
        present_pieces_check = Piece.where(column_coordinate: col, row_coordinate: row_coordinate).present?
        return true if present_pieces_check
      end
    end
    false
  end

  def horizontal_obstruction_right?(destination_x, destination_y)
    if destination_x > column_coordinate && horizontal_move?(destination_y)
      ((column_coordinate + 1)..(destination_x - 1)).each do |col|
        present_pieces_check = Piece.where(column_coordinate: col, row_coordinate: row_coordinate).present?
        return true if present_pieces_check
      end
    end
    false
  end

  def vertical_obstruction_up?(destination_x, destination_y)
    if destination_y > row_coordinate && vertical_move?(destination_x)
      ((row_coordinate + 1)..(destination_y - 1)).each do |row|
        present_pieces_check = Piece.where(row_coordinate: row, column_coordinate: column_coordinate).present?
        return true if present_pieces_check
      end
    end
    false
  end

  def vertical_obstruction_down?(destination_x, destination_y)
    if destination_y < row_coordinate && vertical_move?(destination_x)
      ((destination_y + 1)..(row_coordinate - 1)).each do |row|
        present_pieces_check = Piece.where(row_coordinate: row, column_coordinate: column_coordinate).present?
        return true if present_pieces_check
      end
    end
    false
  end

  def diagonal_obstruction_up_right?(destination_x, destination_y)
    if destination_y > row_coordinate && destination_x > column_coordinate && diagonal_up_and_right_move?(destination_x, destination_y)
      ((row_coordinate + 1)..(destination_y - 1)).each_with_index do |row, index|
        index += 1
        present_pieces_check = Piece.where(row_coordinate: row, column_coordinate: column_coordinate + index).present?
        return true if present_pieces_check
      end
    end
    false
  end

  def diagonal_obstruction_down_left?(destination_x, destination_y)
    if destination_y < row_coordinate && destination_x < column_coordinate && diagonal_down_and_left_move?(destination_x, destination_y)
      ((destination_y + 1)..(row_coordinate - 1)).each_with_index do |row, index|
        index += 1
        present_pieces_check = Piece.where(row_coordinate: row, column_coordinate: column_coordinate - index).present?
        return true if present_pieces_check
      end
    end
    false
  end

  def diagonal_obstruction_up_left?(destination_x, destination_y)
    if destination_y > row_coordinate && destination_x < column_coordinate && diagonal_up_and_left_move?(destination_x, destination_y)
      ((row_coordinate + 1)..(destination_y - 1)).each_with_index do |row, index|
        index += 1
        present_pieces_check = Piece.where(row_coordinate: row, column_coordinate: column_coordinate - index).present?
        return true if present_pieces_check
      end
    end
    false
  end

  def diagonal_obstruction_down_right?(destination_x, destination_y)
    if destination_y < row_coordinate && destination_x > column_coordinate && diagonal_down_and_right_move?(destination_x, destination_y)
      ((destination_y + 1)..(row_coordinate - 1)).to_a.reverse.each_with_index do |row, index|
        index += 1
        present_pieces_check = Piece.where(row_coordinate: row, column_coordinate: column_coordinate + index).present?
        return true if present_pieces_check
      end
    end
    false
  end
end

