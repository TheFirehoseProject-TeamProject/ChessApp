class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game

  def self.types
    %w(King Queen Rook Bishop Knight Pawn)
  end

  def obstructed?(destination_x, destination_y)
    @destination_x = destination_x
    @destination_y = destination_y
    return 'Error: Invalid Input' if invalid_input?
    return true if horizontal? || vertically? || diagonal_up_right_down_left? || diagonal_up_left_down_right?
    return false
  end

  def horizontal?
    if @destination_x < self.column_coordinate && @destination_y == self.row_coordinate #checking left
      ((@destination_x+1)..(self.column_coordinate - 1)).each do |col|
        result = Piece.where(column_coordinate: col, row_coordinate: self.row_coordinate).present?
        return true if result
      end
      return false
    end
   if @destination_x > self.column_coordinate && @destination_y == self.row_coordinate #checking right
      ((self.column_coordinate + 1)..(@destination_x-1)).each do |col|
      result = Piece.where(column_coordinate: col, row_coordinate: self.row_coordinate).present?
        return true if result
      end
      return false
    end
  end

  def vertically?
    if @destination_y > self.row_coordinate && @destination_x == self.column_coordinate #checking up
      ((self.row_coordinate + 1)..(@destination_y -1)).each do |row|
        result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate).present?
        return true if result
      end
      return false
    end
    if @destination_y < self.row_coordinate && @destination_x == self.column_coordinate #checking down
      ((@destination_y + 1)..(self.row_coordinate - 1)).each do |row|
        result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate).present?
        return true if result
      end
      return false
    end
  end

  def diagonal_up_right_down_left? #   /
    length1 = (@destination_x - @destination_y)
    length2 = (self.column_coordinate - self.row_coordinate)
    if @destination_y > self.row_coordinate && @destination_x > self.column_coordinate && length1 == length2 #checking up right
      ((self.row_coordinate + 1 )..(@destination_y - 1)).each_with_index do |row, index|
        index+= 1
        result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate + index).present?
        return true if result
      end
      return false
    end
    if @destination_y < self.row_coordinate && @destination_x < self.column_coordinate && length1 == length2 #checking down left
      ((@destination_y + 1)..(self.row_coordinate - 1 )).each_with_index do |row, index|
        index+= 1
        result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate - index).present?
        return true if result
      end
      return false
    end
  end

  def diagonal_up_left_down_right? #  \
    length1 = (self.column_coordinate - @destination_x)
    length2 = (@destination_y - self.row_coordinate)
    if @destination_y > self.row_coordinate && @destination_x < self.column_coordinate && length1 == length2 #checking up left
      ((self.row_coordinate + 1 )..(@destination_y - 1)).each_with_index do |row, index|
        index+= 1
        result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate - index).present?
        return true if result
      end
      return false
    end
    if @destination_y < self.row_coordinate && @destination_x > self.column_coordinate && length1 == length2 #checking down right
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
    return true if horizontal?.nil? && vertically?.nil? && diagonal_up_right_down_left?.nil? && diagonal_up_left_down_right?.nil?
  end
c
end
