require 'rails_helper'

RSpec.describe Piece, type: :model do
  before do
    FactoryGirl.create(:game)
    FactoryGirl.create(:user)
  end

  piece do
    FactoryGirl.create(:piece)
  end

  describe 'method obstruced # checking if fields are obstructed horizontally' do
    it 'should return false if no piece exists between destination and origin (left or right)' do
      expect(piece.obstructed?(0, 4)).to eq false # checking left side
      expect(piece.obstructed?(7, 4)).to eq false # checking right side
    end
    it 'should return true if piece is between destination and origin (left or right)' do
      FactoryGirl.create(:piece, column_coordinate: 1, row_coordinate: 4)
      FactoryGirl.create(:piece, column_coordinate: 6, row_coordinate: 4)
      expect(piece.obstructed?(0, 4)).to eq true # checking left side
      expect(piece.obstructed?(7, 4)).to eq true # checking right side
    end
    it 'should return false if a piece is at the destination field (left or right)' do
      FactoryGirl.create(:piece, column_coordinate: 0, row_coordinate: 4)
      FactoryGirl.create(:piece, column_coordinate: 7, row_coordinate: 4)
      expect(piece.obstructed?(0, 4)).to eq false  # checking left side
      expect(piece.obstructed?(7, 4)).to eq false  # checking right side
    end
  end

  describe 'method obstruced # checking if fields are obstructed vertically' do
    it 'should return false if no piece exists between' do
      expect(piece.obstructed?(4, 0)).to eq false
    end
    it 'should return true if piece is between destination and origin (below or above)' do
      FactoryGirl.create(:piece, column_coordinate: 4, row_coordinate: 2)
      FactoryGirl.create(:piece, column_coordinate: 4, row_coordinate: 6)
      expect(piece.obstructed?(4, 0)).to eq true  # checking below
      expect(piece.obstructed?(4, 7)).to eq true  # checking above
    end
    it 'should return false if a piece is at the destination field (ablow or above)' do
      FactoryGirl.create(:piece, column_coordinate: 4, row_coordinate: 0)
      FactoryGirl.create(:piece, column_coordinate: 4, row_coordinate: 7)
      expect(piece.obstructed?(4, 0)).to eq false # checking below
      expect(piece.obstructed?(4, 7)).to eq false # checking above
    end
  end

  describe 'method obstructed # checking if field are obstructed diagonal' do
    it 'should return false if no piece exist in between' do
      expect(piece.obstructed?(7, 7)).to eq false
      expect(piece.obstructed?(0, 0)).to eq false
    end
    it 'should return true if there is a piece between destination and origin (upper right)' do
      FactoryGirl.create(:piece, column_coordinate: 6, row_coordinate: 6)
      FactoryGirl.create(:piece, column_coordinate: 5, row_coordinate: 6)
      expect(piece.obstructed?(7, 7)).to eq true
    end
    it 'should return true if there is a piece between destination and origin (lower left)' do
      FactoryGirl.create(:piece, column_coordinate: 2, row_coordinate: 2)
      FactoryGirl.create(:piece, column_coordinate: 1, row_coordinate: 2)
      expect(piece.obstructed?(0, 0)).to eq true
    end
    it 'should return true if there is a piece between destination and origin (upper left)' do
      FactoryGirl.create(:piece, column_coordinate: 2, row_coordinate: 6)
      expect(piece.obstructed?(1, 7)).to eq true
    end
    it 'should return true if there is a piece between destination and origin (lower right)' do
      FactoryGirl.create(:piece, column_coordinate: 6, row_coordinate: 2)
      expect(piece.obstructed?(7, 1)).to eq true
    end
  end

  describe 'method obstructed # checking for invalid input' do
    it 'should return an error if destination is outside of board' do
      expect(piece.obstructed?(8, 8)).to eq 'Error: Invalid Input'
      expect(piece.obstructed?(-1, 4)).to eq 'Error: Invalid Input'
      expect(piece.obstructed?(4, 8)).to eq 'Error: Invalid Input'
    end
    it 'should return an error if move is invalid' do
      expect(piece.obstructed?(1, 5)).to eq 'Error: Invalid Input'
    end
  end
end
