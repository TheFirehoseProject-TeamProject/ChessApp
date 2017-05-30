require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe '.is_obstructed horizontally' do
    it 'should return false if no piece exists between' do
      game1 = Game.create(id: 1)
      user1 = User.create(id: 1, email: '123@123.com', password: '123456', game_id: 1)
      piece1 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 0, row_coordinate: 0)
      piece2 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 5, row_coordinate: 0)
      piece2
      expect(piece1.obstructed?(3, 0)).to eq false
      expect(piece1.obstructed?(6, 0)).to eq true
    end
  end
end
