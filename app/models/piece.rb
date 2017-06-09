class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game

  def self.types
    %w[King Queen Rook Bishop Knight Pawn]
  end

  def self.color
    %w[White Black]
  end

  def move_to!(piece, destination_x, destination_y)
    # moving_piece = Piece.find_by column_coordinate: column_coordinate, row_coordinate: row_coordinate

    destination_piece_check = Piece.find_by column_coordinate: destination_x, row_coordinate: destination_y
    piece.update_attributes(column_coordinate: destination_x, row_coordinate: destination_y)
    piece
    # removed_piece = remove_piece(destination_x, destination_y) if destination_piece_check.present?
    # moving_piece.update_attributes(column_coordinate: destination_x, row_coordinate: destination_y)
    # moving_piece
  end

  def obstructed?(destination_x, destination_y)
    raise 'Error: Invalid Input' if destination_y > 7 || destination_x > 7 || destination_y < 0 || destination_x < 0

    if horizontal_move?(destination_y)
      return horizontal_obstruction_left?(destination_x) || horizontal_obstruction_right?(destination_x)
    end

    if vertical_move?(destination_x)
      return vertical_obstruction_up?(destination_y) || vertical_obstruction_down?(destination_y)
    end

    if diagonal_up_and_right_move?(destination_x, destination_y)
      return diagonal_obstruction_up_right?(destination_y)
    end

    if diagonal_down_and_left_move?(destination_x, destination_y)
      return diagonal_obstruction_down_left?(destination_y)
    end

    if diagonal_up_and_left_move?(destination_x, destination_y)
      return diagonal_obstruction_up_left?(destination_y)
    end

    if diagonal_down_and_right_move?(destination_x, destination_y)
      return diagonal_obstruction_down_right?(destination_y)
    end

    raise 'Error: Invalid Input'
  end

  private

  def remove_piece(destination_x, destination_y)
    destination_piece = Piece.find_by column_coordinate: destination_x, row_coordinate: destination_y
    destination_piece[:is_on_board?] = false
    destination_piece
  end

  def horizontal_move?(destination_y)
    return true if destination_y == row_coordinate
    false
  end

  def vertical_move?(destination_x)
    return true if destination_x == column_coordinate
    false
  end

  def diagonal_up_and_right_move?(destination_x, destination_y)
    if destination_x > column_coordinate && destination_y > row_coordinate
      diagonal_move_check_destination_up_and_right = destination_x - destination_y
      diagonal_move_check_origin_up_and_right = column_coordinate - row_coordinate
      return true if diagonal_move_check_destination_up_and_right == diagonal_move_check_origin_up_and_right
      false
    end
    false
  end

  def diagonal_down_and_left_move?(destination_x, destination_y)
    if destination_x < column_coordinate && destination_y < row_coordinate
      diagonal_move_check_destination_down_and_left = destination_x - destination_y
      diagonal_move_check_origin_down_and_left = column_coordinate - row_coordinate
      return true if diagonal_move_check_destination_down_and_left == diagonal_move_check_origin_down_and_left
      false
    end
    false
  end

  def diagonal_up_and_left_move?(destination_x, destination_y)
    if destination_x < column_coordinate && destination_y > row_coordinate
      diagonal_move_check_column_up_and_left = column_coordinate - destination_x
      diagonal_move_check_row_up_and_left = destination_y - row_coordinate
      return true if diagonal_move_check_column_up_and_left == diagonal_move_check_row_up_and_left
      false
    end
    false
  end

  def diagonal_down_and_right_move?(destination_x, destination_y)
    if destination_x > column_coordinate && destination_y < row_coordinate
      diagonal_move_check_column_down_and_right = column_coordinate - destination_x
      diagonal_move_check_row_down_and_right = destination_y - row_coordinate
      return true if diagonal_move_check_column_down_and_right == diagonal_move_check_row_down_and_right
      false
    end
    false
  end

  def horizontal_obstruction_left?(destination_x)
    ((destination_x + 1)..(column_coordinate - 1)).each do |col|
      present_pieces_check = Piece.where(column_coordinate: col, row_coordinate: row_coordinate).present?
      return true if present_pieces_check
    end
    false
  end

  def horizontal_obstruction_right?(destination_x)
    ((column_coordinate + 1)..(destination_x - 1)).each do |col|
      present_pieces_check = Piece.where(column_coordinate: col, row_coordinate: row_coordinate).present?
      return true if present_pieces_check
    end
    false
  end

  def vertical_obstruction_up?(destination_y)
    ((row_coordinate + 1)..(destination_y - 1)).each do |row|
      present_pieces_check = Piece.where(row_coordinate: row, column_coordinate: column_coordinate).present?
      return true if present_pieces_check
    end
    false
  end

  def vertical_obstruction_down?(destination_y)
    ((destination_y + 1)..(row_coordinate - 1)).each do |row|
      present_pieces_check = Piece.where(row_coordinate: row, column_coordinate: column_coordinate).present?
      return true if present_pieces_check
    end
    false
  end

  def diagonal_obstruction_up_right?(destination_y)
    ((row_coordinate + 1)..(destination_y - 1)).each_with_index do |row, index|
      index += 1
      present_pieces_check = Piece.where(row_coordinate: row, column_coordinate: column_coordinate + index).present?
      return true if present_pieces_check
    end
    false
  end

  def diagonal_obstruction_down_left?(destination_y)
    ((destination_y + 1)..(row_coordinate - 1)).each_with_index do |row, index|
      index += 1
      present_pieces_check = Piece.where(row_coordinate: row, column_coordinate: column_coordinate - index).present?
      return true if present_pieces_check
    end
    false
  end

  def diagonal_obstruction_up_left?(destination_y)
    ((row_coordinate + 1)..(destination_y - 1)).each_with_index do |row, index|
      index += 1
      present_pieces_check = Piece.where(row_coordinate: row, column_coordinate: column_coordinate - index).present?
      return true if present_pieces_check
    end
    false
  end

  def diagonal_obstruction_down_right?(destination_y)
    ((destination_y + 1)..(row_coordinate - 1)).to_a.reverse.each_with_index do |row, index|
      index += 1
      present_pieces_check = Piece.where(row_coordinate: row, column_coordinate: column_coordinate + index).present?
      return true if present_pieces_check
    end
    false
  end
end
