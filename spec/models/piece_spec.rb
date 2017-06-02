require 'rails_helper'

RSpec.describe Piece, type: :model do

  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }
  let(:piece) { FactoryGirl.create(:piece, :is_on_board) }

  describe 'method obstruced # checking if fields are obstructed horizontally' do
    it 'should return false if no piece exists between destination and origin when going left' do
      expect(piece.obstructed?(0, 4)).to eq false
    end
    it 'should return false if no piece exists between destination and origin when going right' do
      expect(piece.obstructed?(7, 4)).to eq false
    end
    it 'should return true if piece is between destination and origin when going left' do
      FactoryGirl.create(:piece, column_coordinate: 1, row_coordinate: 4)
      expect(piece.obstructed?(0, 4)).to eq true
    end
    it 'should return true if piece is between destination and origin when going right' do
      FactoryGirl.create(:piece, column_coordinate: 6, row_coordinate: 4)
      expect(piece.obstructed?(7, 4)).to eq true
    end
    it 'should return false if a piece is at the destination field left when going left' do
      FactoryGirl.create(:piece, column_coordinate: 0, row_coordinate: 4)
      expect(piece.obstructed?(0, 4)).to eq false
    end
    it 'should return false if a piece is at the destination field when going right' do
      FactoryGirl.create(:piece, column_coordinate: 7, row_coordinate: 4)
      expect(piece.obstructed?(7, 4)).to eq false
    end
  end

  describe 'method obstruced # checking if fields are obstructed vertically' do
    it 'should return false if no piece exists between destination and origin when going down' do
      expect(piece.obstructed?(4, 0)).to eq false
    end
    it 'should return false if no piece exists between destination and origin when going up' do
      expect(piece.obstructed?(4, 7)).to eq false
    end
    it 'should return true if piece is between destination and origin when going down' do
      FactoryGirl.create(:piece, column_coordinate: 4, row_coordinate: 2)
      expect(piece.obstructed?(4, 0)).to eq true
    end
    it 'should return true if piece is between destination and origin when going up' do
      FactoryGirl.create(:piece, column_coordinate: 4, row_coordinate: 6)
      expect(piece.obstructed?(4, 7)).to eq true  # checking above
    end
    it 'should return false if a piece is at the destination field when going down' do
      FactoryGirl.create(:piece, column_coordinate: 4, row_coordinate: 0)
      expect(piece.obstructed?(4, 0)).to eq false
    end
    it 'should return false if a piece is at the destination field when going up' do
      FactoryGirl.create(:piece, column_coordinate: 4, row_coordinate: 7)
      expect(piece.obstructed?(4, 7)).to eq false # checking above
    end
  end

  describe 'method obstructed # checking if field are obstructed diagonal' do
    it 'should return false if no piece exist in between when going up and right' do
      expect(piece.obstructed?(7, 7)).to eq false
    end
    it 'should return false if no piece exist in between when going down and left' do
      expect(piece.obstructed?(0, 0)).to eq false
    end
    it 'should return false if no piece exist in between when going up and left' do
      expect(piece.obstructed?(1, 7)).to eq false
    end
    it 'should return false if no piece exist in between when going down and right' do
      expect(piece.obstructed?(7, 1)).to eq false
    end
    it 'should return true if there is a piece between destination and origin when going up and right' do
      FactoryGirl.create(:piece, column_coordinate: 6, row_coordinate: 6)
      expect(piece.obstructed?(7, 7)).to eq true
    end
    it 'should return true if there is a piece between destination and origin when going down and left' do
      FactoryGirl.create(:piece, column_coordinate: 2, row_coordinate: 2)
      expect(piece.obstructed?(0, 0)).to eq true
    end
    it 'should return true if there is a piece between destination and origin when going up and left' do
      FactoryGirl.create(:piece, column_coordinate: 2, row_coordinate: 6)
      expect(piece.obstructed?(1, 7)).to eq true
    end
    it 'should return true if there is a piece between destination and origin when going down and right' do
      FactoryGirl.create(:piece, column_coordinate: 6, row_coordinate: 2)
      expect(piece.obstructed?(7, 1)).to eq true
    end
  end

  describe 'method obstructed # checking for invalid input' do
    it 'should return an error if destination column is off the board right' do
      expect { piece.obstructed?(8, 5) }.to raise_error('Error: Invalid Input')
    end
    it 'should return an error if destination row is off the board up' do
      expect { piece.obstructed?(3, 9) }.to raise_error('Error: Invalid Input')
    end
    it 'should return an error if destination column is off the board left' do
      expect { piece.obstructed?(-2, 5) }.to raise_error('Error: Invalid Input')
    end
    it 'should return an error if destination row is off the board down' do
      expect { piece.obstructed?(5, -1) }.to raise_error('Error: Invalid Input')
    end
    it 'should return an error if move is invalid' do
      expect(piece.obstructed?(1, 5)).to eq 'Error: Invalid Input'
    end
  end
end
