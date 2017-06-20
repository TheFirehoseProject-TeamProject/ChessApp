require 'rails_helper'

RSpec.describe Piece, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user, game: game) }
  let(:piece_black) { FactoryGirl.create(:queen, color: 'black', game: game, column_coordinate: 4, row_coordinate: 4) }

  describe '#move_to_empty_space' do
    it 'moves to empty space' do
      expect(piece_black.move_to_empty_space(destination_x: 3, destination_y: 5)).to eq true
    end
  end

  describe '#move_to!' do
    context 'when no piece is at destination coordinates' do
      it 'moves to the destination coordinates' do
        piece_black.move_to!(3, 5)
        expect(piece_black).to have_attributes(column_coordinate: 3, row_coordinate: 5)
      end
    end
    context 'when a piece exists at the destination and it is the opposite color' do
      let!(:piece_white) { FactoryGirl.create(:piece, :is_on_board_white, game: game) }
      it 'moves to new destination coordinates' do
        piece_black.move_to!(3, 5)
        piece_white.reload
        expect(piece_black).to have_attributes(column_coordinate: 3, row_coordinate: 5)
      end
      it 'the other piece is removed from the board' do
        piece_black.move_to!(3, 5)
        piece_white.reload
        expect(piece_white[:is_on_board?]).to eq false
      end
    end

    context 'when a piece exists at the destination and it is the same color' do
      it 'returns an error: Invalid move' do
        FactoryGirl.create(:piece, column_coordinate: 3, row_coordinate: 5, color: 'black', is_on_board?: true, game: game)
        expect { piece_black.move_to!(3, 5) }.to raise_error('Invalid Move')
      end
    end
  end

  describe 'method obstruced # checking if fields are obstructed horizontally' do
    it 'should return false if no piece exists between destination and origin when going left' do
      expect(piece_black.obstructed?(0, 4)).to eq false
    end
    it 'should return false if no piece exists between destination and origin when going right' do
      expect(piece_black.obstructed?(7, 4)).to eq false
    end
    it 'should return true if piece is between destination and origin when going left' do
      FactoryGirl.create(:piece, column_coordinate: 1, row_coordinate: 4, is_on_board?: true, game: game)
      expect(piece_black.obstructed?(0, 4)).to eq true
    end
    it 'should return true if piece is between destination and origin when going right' do
      FactoryGirl.create(:piece, column_coordinate: 6, row_coordinate: 4, is_on_board?: true, game: game)
      expect(piece_black.obstructed?(7, 4)).to eq true
    end
    it 'should return false if a piece is at the destination field left when going left' do
      FactoryGirl.create(:piece, column_coordinate: 0, row_coordinate: 4, is_on_board?: true, game: game)
      expect(piece_black.obstructed?(0, 4)).to eq false
    end
    it 'should return false if a piece is at the destination field when going right' do
      FactoryGirl.create(:piece, column_coordinate: 7, row_coordinate: 4, is_on_board?: true, game: game)
      expect(piece_black.obstructed?(7, 4)).to eq false
    end
  end

  describe 'method obstruced # checking if fields are obstructed vertically' do
    it 'should return false if no piece exists between destination and origin when going down' do
      expect(piece_black.obstructed?(4, 0)).to eq false
    end
    it 'should return false if no piece exists between destination and origin when going up' do
      expect(piece_black.obstructed?(4, 7)).to eq false
    end
    it 'should return true if piece is between destination and origin when going down' do
      FactoryGirl.create(:piece, column_coordinate: 4, row_coordinate: 2, is_on_board?: true, game: game)
      expect(piece_black.obstructed?(4, 0)).to eq true
    end
    it 'should return true if piece is between destination and origin when going up' do
      FactoryGirl.create(:piece, column_coordinate: 4, row_coordinate: 6, is_on_board?: true, game: game)
      expect(piece_black.obstructed?(4, 7)).to eq true  # checking above
    end
    it 'should return false if a piece is at the destination field when going down' do
      FactoryGirl.create(:piece, column_coordinate: 4, row_coordinate: 0, is_on_board?: true, game: game)
      expect(piece_black.obstructed?(4, 0)).to eq false
    end
    it 'should return false if a piece is at the destination field when going up' do
      FactoryGirl.create(:piece, column_coordinate: 4, row_coordinate: 7, is_on_board?: true, game: game)
      expect(piece_black.obstructed?(4, 7)).to eq false # checking above
    end
  end

  describe 'method obstructed # checking if field are obstructed diagonal' do
    it 'should return false if no piece exist in between when going up and right' do
      expect(piece_black.obstructed?(7, 7)).to eq false
    end
    it 'should return false if no piece exist in between when going down and left' do
      expect(piece_black.obstructed?(0, 0)).to eq false
    end
    it 'should return false if no piece exist in between when going up and left' do
      expect(piece_black.obstructed?(1, 7)).to eq false
    end
    it 'should return false if no piece exist in between when going down and right' do
      expect(piece_black.obstructed?(7, 1)).to eq false
    end
    it 'should return true if there is a piece between destination and origin when going up and right' do
      FactoryGirl.create(:piece, column_coordinate: 6, row_coordinate: 6, is_on_board?: true, game: game)
      expect(piece_black.obstructed?(7, 7)).to eq true
    end
    it 'should return true if there is a piece between destination and origin when going down and left' do
      FactoryGirl.create(:piece, column_coordinate: 2, row_coordinate: 2, is_on_board?: true, game: game)
      expect(piece_black.obstructed?(0, 0)).to eq true
    end
    it 'should return true if there is a piece between destination and origin when going up and left' do
      FactoryGirl.create(:piece, column_coordinate: 2, row_coordinate: 6, is_on_board?: true, game: game)
      expect(piece_black.obstructed?(1, 7)).to eq true
    end
    it 'should return true if there is a piece between destination and origin when going down and right' do
      FactoryGirl.create(:piece, column_coordinate: 6, row_coordinate: 2, is_on_board?: true, game: game)
      expect(piece_black.obstructed?(7, 1)).to eq true
    end
  end

  describe 'method obstructed # checking for invalid input' do
    it 'should return an error if destination column is off the board right' do
      expect { piece_black.obstructed?(8, 5) }.to raise_error('Error: Invalid Input')
    end
    it 'should return an error if destination row is off the board up' do
      expect { piece_black.obstructed?(3, 9) }.to raise_error('Error: Invalid Input')
    end
    it 'should return an error if destination column is off the board left' do
      expect { piece_black.obstructed?(-2, 5) }.to raise_error('Error: Invalid Input')
    end
    it 'should return an error if destination row is off the board down' do
      expect { piece_black.obstructed?(5, -1) }.to raise_error('Error: Invalid Input')
    end
    it 'should return an error if move is invalid' do
      expect { piece_black.obstructed?(1, 5) }.to raise_error('Error: Invalid Input')
    end
  end
end
