class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game

  def self.types
    %w[king queen rook bishop knight pawn]
  end

  def self.color
    %w[white black]
  end

  def move_to!(destination_x, destination_y)
    save_piece_capturable_by_en_passant(destination_x, destination_y)
    destination_piece = game.pieces.find_by(column_coordinate: destination_x, row_coordinate: destination_y, is_on_board?: true)
    raise 'Invalid Move' if destination_piece.present? && !capturable?(destination_piece)
    if en_passant_move?(destination_x, destination_y)
      pawn_to_capture = find_en_passant_pawn_to_capture(destination_x, destination_y)
      move_to_destination_and_capture!(pawn_to_capture, destination_x, destination_y)
    elsif destination_piece.nil?
      move_to_empty_space(destination_x, destination_y)
    else
      capture!(destination_piece)
    end
  end

  def save_piece_capturable_by_en_passant(destination_x, destination_y)
    return nil if en_passant_move?(destination_x, destination_y)
    return game.update(piece_capturable_by_en_passant: '') unless type == 'Pawn' && en_passant_situation?(destination_x, destination_y)
    game.update(piece_capturable_by_en_passant: id)
  end

  def move_to_destination_and_capture!(pawn_to_capture, destination_x, destination_y)
    update_attributes(column_coordinate: destination_x, row_coordinate: destination_y)
    remove_piece(pawn_to_capture)
    game.update(piece_capturable_by_en_passant: '')
  end

  def move_to_empty_space(destination_x, destination_y)
    update_attributes(column_coordinate: destination_x, row_coordinate: destination_y)
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
    raise 'Error: Invalid Input' unless type == 'Knight'
  end

  private

  def capturable?(destination_piece)
    destination_piece.present? && destination_piece.color != color
  end

  def capture!(destination_piece)
    move_to_empty_space(destination_piece.column_coordinate, destination_piece.row_coordinate)
    remove_piece(destination_piece)
  end

  def remove_piece(piece_to_remove)
    piece_to_remove.update_attributes(is_on_board?: false, row_coordinate: -1, column_coordinate: -1)
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
      present_pieces_check = game.pieces.where(column_coordinate: col, row_coordinate: row_coordinate).present?
      return true if present_pieces_check
    end
    false
  end

  def horizontal_obstruction_right?(destination_x)
    ((column_coordinate + 1)..(destination_x - 1)).each do |col|
      present_pieces_check = game.pieces.where(column_coordinate: col, row_coordinate: row_coordinate).present?
      return true if present_pieces_check
    end
    false
  end

  def vertical_obstruction_up?(destination_y)
    ((row_coordinate + 1)..(destination_y - 1)).each do |row|
      present_pieces_check = game.pieces.where(row_coordinate: row, column_coordinate: column_coordinate).present?
      return true if present_pieces_check
    end
    false
  end

  def vertical_obstruction_down?(destination_y)
    ((destination_y + 1)..(row_coordinate - 1)).each do |row|
      present_pieces_check = game.pieces.where(row_coordinate: row, column_coordinate: column_coordinate).present?
      return true if present_pieces_check
    end
    false
  end

  def diagonal_obstruction_up_right?(destination_y)
    ((row_coordinate + 1)..(destination_y - 1)).each_with_index do |row, index|
      index += 1
      present_pieces_check = game.pieces.where(row_coordinate: row, column_coordinate: column_coordinate + index).present?
      return true if present_pieces_check
    end
    false
  end

  def diagonal_obstruction_down_left?(destination_y)
    ((destination_y + 1)..(row_coordinate - 1)).each_with_index do |row, index|
      index += 1
      present_pieces_check = game.pieces.where(row_coordinate: row, column_coordinate: column_coordinate - index).present?
      return true if present_pieces_check
    end
    false
  end

  def diagonal_obstruction_up_left?(destination_y)
    ((row_coordinate + 1)..(destination_y - 1)).each_with_index do |row, index|
      index += 1
      present_pieces_check = game.pieces.where(row_coordinate: row, column_coordinate: column_coordinate - index).present?
      return true if present_pieces_check
    end
    false
  end

  def diagonal_obstruction_down_right?(destination_y)
    ((destination_y + 1)..(row_coordinate - 1)).to_a.reverse.each_with_index do |row, index|
      index += 1
      present_pieces_check = game.pieces.where(row_coordinate: row, column_coordinate: column_coordinate + index).present?
      return true if present_pieces_check
    end
    false
  end
end
