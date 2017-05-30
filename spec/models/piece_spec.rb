require 'rails_helper'

RSpec.describe Piece, type: :model do

  describe 'method obstruced # checking if fields are obstructed horizontally' do
    it 'should return false if no piece exists between destination and origin (left or right)' do
      game1 = Game.create(id: 1)
      user1 = User.create(id: 1, email: '123@123.com', password: '123456', game_id: 1)
      piece1 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 4, row_coordinate: 0)
      expect(piece1.obstructed?(0, 0)).to eq false #checking left side
      expect(piece1.obstructed?(7, 0)).to eq false #checking right side
    end
    it "should return true if piece is between destination and origin (left or right) " do
      game1 = Game.create(id: 1)
      user1 = User.create(id: 1, email: '123@123.com', password: '123456', game_id: 1)
      piece1 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 4, row_coordinate: 0)
      piece2 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 1, row_coordinate: 0)
      piece3 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 6, row_coordinate: 0)
      expect(piece1.obstructed?(0, 0)).to eq true #checking left side
      expect(piece1.obstructed?(7, 0)).to eq true  #checking right side
    end
    it "should return false if a piece is at the destination field (left or right)" do
      game1 = Game.create(id: 1)
      user1 = User.create(id: 1, email: '123@123.com', password: '123456', game_id: 1)
      piece1 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 4, row_coordinate: 0)
      piece2 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 0, row_coordinate: 0)
      piece3 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 7, row_coordinate: 0)
      expect(piece1.obstructed?(0, 0)).to eq false  #checking left side
      expect(piece1.obstructed?(7, 0)).to eq false  #checking right side
    end
  end

  describe 'method obstruced # checking if fields are obstructed vertically' do
    it 'should return false if no piece exists between' do
      game1 = Game.create(id: 1)
      user1 = User.create(id: 1, email: '123@123.com', password: '123456', game_id: 1)
      piece1 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 4, row_coordinate: 4)
      expect(piece1.obstructed?(4, 0)).to eq false
    end
    it "should return true if piece is between destination and origin (below or above) " do
      game1 = Game.create(id: 1)
      user1 = User.create(id: 1, email: '123@123.com', password: '123456', game_id: 1)
      piece1 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 4, row_coordinate: 4)
      piece2 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 4, row_coordinate: 2)
      piece3 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 4, row_coordinate: 6)
      expect(piece1.obstructed?(4, 0)).to eq true  #checking below
      expect(piece1.obstructed?(4, 7)).to eq true  #checking above
    end
    it "should return false if a piece is at the destination field (ablow or above)" do
      game1 = Game.create(id: 1)
      user1 = User.create(id: 1, email: '123@123.com', password: '123456', game_id: 1)
      piece1 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 4, row_coordinate: 4)
      piece2 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 4, row_coordinate: 0)
      piece3 = Piece.create(game_id: 1, user_id: 1, column_coordinate: 4, row_coordinate: 7)
      expect(piece1.obstructed?(4, 0)).to eq false #checking below
      expect(piece1.obstructed?(4, 7)).to eq false #checking above
    end
  end
end
