class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game

  def self.types
    %w(King Queen Rook Bishop Knight Pawn)
  end

  def obstructed?(destination_x, destination_y)
      result = false
      length1_perp = (destination_x - destination_y)
      length2_perp = (self.column_coordinate - self.row_coordinate)
      length1_diag = (self.column_coordinate - destination_x)
      length2_diag = (destination_y - self.row_coordinate)

      return "Error Message" if destination_y > 7 || destination_x > 7 || destination_y < 0 || destination_x < 0

      # ----------------------case 1: horizontal move--------------------------
      if destination_x > self.column_coordinate && destination_y == self.row_coordinate
        ((self.column_coordinate + 1)..(destination_x-1)).each do |col|
        result = Piece.where(column_coordinate: col, row_coordinate: self.row_coordinate).present?
          return result if result == true
        end
      end
      if destination_x < self.column_coordinate && destination_y == self.row_coordinate
        ((destination_x+1)..(self.column_coordinate - 1)).each do |col|
          result = Piece.where(column_coordinate: col, row_coordinate: self.row_coordinate).present?
          return result if result == true
        end
      end
      # -----------------------case 2: vertical move---------------------------
      if destination_y > self.row_coordinate && destination_x == self.column_coordinate
        ((self.row_coordinate + 1)..(destination_y -1)).each do |row|
          result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate).present?
          return result if result == true
        end
      end
      if destination_y < self.row_coordinate && destination_x == self.column_coordinate
        ((destination_y + 1)..(self.row_coordinate - 1)).each do |row|
          result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate).present?
          return result if result == true
        end
      end
      #-----------------------case 3: diagonal move up right-------------------------
      if destination_y > self.row_coordinate && destination_x > self.column_coordinate && length1_perp == length2_perp
        ((self.row_coordinate + 1 )..(destination_y - 1)).each_with_index do |row, index|
          index+= 1
          result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate + index).present?
          return result if result == true
        end
      end
      #-----------------------case 4: diagonal move down left-------------------------
      if destination_y < self.row_coordinate && destination_x < self.column_coordinate && length1_perp == length2_perp
        ((destination_y + 1)..(self.row_coordinate - 1 )).each_with_index do |row, index|
          index+= 1
          result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate - index).present?
          return result if result == true
        end
      end


      #-----------------------case 5: diagonal move up left-------------------------
            if destination_y > self.row_coordinate && destination_x < self.column_coordinate && length1_diag == length2_diag
        ((self.row_coordinate + 1 )..(destination_y - 1)).each_with_index do |row, index|
          index+= 1
          result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate - index).present?
          return result if result == true
        end
      end
      #-----------------------case 6: diagonal move down right-------------------------
      if destination_y < self.row_coordinate && destination_x > self.column_coordinate
        ((destination_y + 1)..(self.row_coordinate - 1 )).to_a.reverse.each_with_index do |row, index|
          index+= 1
          result = Piece.where(row_coordinate: row, column_coordinate: self.column_coordinate + index).present?
          return result if result == true
        end
      end


    return result
  end
end
