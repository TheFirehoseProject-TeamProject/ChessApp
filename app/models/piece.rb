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
      (destination_x - self.column_coordinate - 1).times do
        Piece.where(column_coordinate: destination_x - counter, row_coordinate: self.row_coordinate).count.zero? ? result = false : result = true
        return result if result == true
        counter += 1
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

  #   array = []
  #   if destination_x > self.column_coordinate
  #     if Piece.where('column_coordinate > ?', self.column_coordinate).present?
  #        array << Piece.where('column_coordinate > ?', self.column_coordinate)
  #        byebug
  #        array.each do |element|
  #          if element.column_coordinate < destination_x && element.column_coordinate != self.column_coordinate
  #            return true
  #          end
  #        end
  #       return false
  #     end
  #   end
  #
  #   if destination_x < self.column_coordinate
  #     if Piece.where('column_coordinate < ?', self.column_coordinate)
  #       return true
  #     end
  #   end
  #   return false
  # end
end
