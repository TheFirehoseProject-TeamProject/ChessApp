class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game

  def self.types
    %w(King Queen Rook Bishop Knight Pawn)
  end

  def obstructed?(destination_x, destination_y)
    # ----------------------case 1: horizontal move--------------------------
    result = false
    if destination_x > self.column_coordinate
      ((self.column_coordinate + 1)..(destination_x-1)).each do |col|
      result = Piece.where(column_coordinate: col, row_coordinate: self.row_coordinate).present?
        return result if result == true
      end
    end
    if destination_x < self.column_coordinate
      ((destination_x+1)..(self.column_coordinate - 1)).each do |col|
        result = Piece.where(column_coordinate: col, row_coordinate: self.row_coordinate).present?
        return result if result == true
      end
    end
    # -----------------------case 2: vertical move---------------------------
    if destination_y > self.row_coordinate
      ((self.row_coordinate + 1)..(destination_y -1)).each do |row|
        result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate).present?
        return result if result == true
      end
    end
    if destination_y < self.row_coordinate
      ((destination_y + 1)..(self.row_coordinate - 1)).each do |row|
        result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate).present?
        return result if result == true
      end
    end
    return result
  end
end
