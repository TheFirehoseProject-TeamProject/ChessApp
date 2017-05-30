class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game

  def self.types
    %w(King Queen Rook Bishop Knight Pawn)
  end

  def obstructed?(destination_x, destination_y)
    # horizontal
    # counter = 1
    # result = false
    # (destination_x - self.column_coordinate - 1).times do
    #   Piece.where(column_coordinate: destination_x - counter, row_coordinate: self.row_coordinate).count.zero? ? result = false : result = true
    #   return result if result == true
    #   counter += 1
    # end
    # return result
    array = []
    if destination_x > self.column_coordinate
      if Piece.where('column_coordinate > ?', self.column_coordinate).present?
         array << Piece.where('column_coordinate > ?', self.column_coordinate)
         byebug
         array.each do |element|
           if element.column_coordinate < destination_x && element.column_coordinate != self.column_coordinate
             return true
           end
         end
        return false
      end
    end

    if destination_x < self.column_coordinate
      if Piece.where('column_coordinate < ?', self.column_coordinate)
        return true
      end
    end
    return false
  end
end
