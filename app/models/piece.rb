class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game

  def self.types
    %w(King Queen Rook Bishop Knight Pawn)
  end

  def obstructed?(destination_x, destination_y)
    # ----------------------case 1: horizontal move--------------------------
    counter = 1
    result = false
    if destination_x > self.column_coordinate
      # (destination_x - self.column_coordinate - 1).times do
      ((self.column_coordinate + 1)..destination_x-1).each do |col|
      result = Piece.where(column_coordinate: col, row_coordinate: self.row_coordinate).present?
        return result if result == true
      end
    end
    if destination_x < self.column_coordinate
      (self.column_coordinate - destination_x - 1).times do
        Piece.where(column_coordinate: destination_x + counter, row_coordinate: self.row_coordinate).count.zero? ? result = false : result = true
        return result if result == true
        counter += 1
      end
    end
    # -----------------------case 2: vertical move---------------------------
    if destination_y > self.row_coordinate
      (destination_y - self.row_coordinate - 1).times do
        Piece.where(row_coordinate: destination_y - counter, column_coordinate: self.column_coordinate).count.zero? ? result = false : result = true
        return result if result == true
        counter += 1
      end
    end
    if destination_y < self.row_coordinate
      (self.row_coordinate - destination_y - 1).times do
        Piece.where(row_coordinate: destination_y + counter, column_coordinate: self.column_coordinate).count.zero? ? result = false : result = true
        return result if result == true
        counter += 1
      end
    end
    return result
  end
# 
#     array = []
#     if destination_x > self.column_coordinate
#       if Piece.where('column_coordinate > ?', self.column_coordinate).present?
# #         array << Piece.where('column_coordinate > ? and row_coordinate > ?', self.column_coordinate, self.row_coordinate)
#          array << Piece.where('column_coordinate > ?', self.column_coordinate).where('row_coordinate > ?', self.row_coordinate)
#          byebug
#          []
#          [ [piece1, piece2], [piece3, piece4]].flatten => [piece1, piece2, piece3, piece4]
#          array.each do |element|
#            if element.column_coordinate < destination_x && element.column_coordinate != self.column_coordinate
#              return true
#            end
#          end
#         return false
#       end
#     end

  #   if destination_x < self.column_coordinate
  #     if Piece.where('column_coordinate < ?', self.column_coordinate)
  #       return true
  #     end
  #   end
  #   return false
  # end
end
