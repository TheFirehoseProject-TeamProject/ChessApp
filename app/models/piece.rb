class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game

  def self.types
    %w(King Queen Rook Bishop Knight Pawn)
  end

  def obstructed?(destination_x, destination_y)
    @destination_x = destination_x
    @destination_y = destination_y
    @length1_diag1 = (destination_x - destination_y)
    @length2_diag1 = (self.column_coordinate - self.row_coordinate)
    @length1_diag2 = (self.column_coordinate - destination_x)
    @length2_diag2 = (destination_y - self.row_coordinate)

    return true if horizontal_right? || horizontal_left? || vertically_up? || vertically_down? || diagonal_up_right? || diagonal_down_left? || diagonal_up_left? || diagonal_down_right?
    return 'Error: Invalid Input' if invalid_input?
    return false
  end

  def horizontal_left?
    if @destination_x < self.column_coordinate && @destination_y == self.row_coordinate
      ((@destination_x+1)..(self.column_coordinate - 1)).each do |col|
        result = Piece.where(column_coordinate: col, row_coordinate: self.row_coordinate).present?
        return true if result
      end
      return false
    end
  end

  def horizontal_right?
    if @destination_x > self.column_coordinate && @destination_y == self.row_coordinate
      ((self.column_coordinate + 1)..(@destination_x-1)).each do |col|
      result = Piece.where(column_coordinate: col, row_coordinate: self.row_coordinate).present?
        return true if result
      end
      return false
    end
  end

  def vertically_up?
    if @destination_y > self.row_coordinate && @destination_x == self.column_coordinate
      ((self.row_coordinate + 1)..(@destination_y -1)).each do |row|
        result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate).present?
        return true if result
      end
      return false
    end
  end

  def vertically_down?
    if @destination_y < self.row_coordinate && @destination_x == self.column_coordinate
      ((@destination_y + 1)..(self.row_coordinate - 1)).each do |row|
        result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate).present?
        return true if result
      end
      return false
    end
  end

  def diagonal_up_right?
    if @destination_y > self.row_coordinate && @destination_x > self.column_coordinate && @length1_diag1 == @length2_diag1
      ((self.row_coordinate + 1 )..(@destination_y - 1)).each_with_index do |row, index|
        index+= 1
        result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate + index).present?
        return true if result
      end
      return false
    end
  end

  def diagonal_down_left?
    if @destination_y < self.row_coordinate && @destination_x < self.column_coordinate && @length1_diag1 == @length2_diag1
      ((@destination_y + 1)..(self.row_coordinate - 1 )).each_with_index do |row, index|
        index+= 1
        result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate - index).present?
        return true if result
      end
      return false
    end
  end

  def diagonal_up_left?
    if @destination_y > self.row_coordinate && @destination_x < self.column_coordinate && @length1_diag2 == @length2_diag2
      ((self.row_coordinate + 1 )..(@destination_y - 1)).each_with_index do |row, index|
        index+= 1
        result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate - index).present?
        return true if result
      end
      return false
    end
  end

  def diagonal_down_right?
    if @destination_y < self.row_coordinate && @destination_x > self.column_coordinate && @length1_diag2 == @length2_diag2
      ((@destination_y + 1)..(self.row_coordinate - 1 )).to_a.reverse.each_with_index do |row, index|
        index+= 1
        result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate + index).present?
        return true if result
      end
      return false
    end
  end

  def invalid_input?
    return true if @destination_y > 7 || @destination_x > 7 || @destination_y < 0 || @destination_x < 0
    return true if horizontal_left?.nil? && horizontal_right?.nil? && vertically_up?.nil? && vertically_down?.nil? && diagonal_up_right?.nil? && diagonal_down_left?.nil? && diagonal_up_left?.nil? && diagonal_down_right?.nil?
  end

end
