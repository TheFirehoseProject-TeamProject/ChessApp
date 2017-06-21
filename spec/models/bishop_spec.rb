require 'rails_helper'

RSpec.describe Bishop, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }
  let(:bishop) { FactoryGirl.create(:bishop, :is_on_board, color: 'black', game: game) }
  describe 'movement of bishop' do
    it 'should only move diagonally' do
      expect(bishop.valid_move?(2, 2)).to eq true
      expect(bishop.valid_move?(4, 2)).to eq true
      expect(bishop.valid_move?(2, 4)).to eq true
      expect(bishop.valid_move?(4, 4)).to eq true
      expect(bishop.valid_move?(0, 0)).to eq true
      expect(bishop.valid_move?(6, 0)).to eq true
      expect(bishop.valid_move?(0, 6)).to eq true
      expect(bishop.valid_move?(6, 6)).to eq true
    end

    it 'should not move horizontally or vertically' do
      expect(bishop.valid_move?(2, 3)).to eq false
      expect(bishop.valid_move?(3, 4)).to eq false
      expect(bishop.valid_move?(3, 2)).to eq false
      expect(bishop.valid_move?(3, 4)).to eq false
    end
  end
  describe '#move_to!' do
    context 'when a move is invalid' do
      it 'should raise error: Invalid Move' do
        expect { bishop.move_to!(2, 3) }.to raise_error('Invalid Move')
        expect { bishop.move_to!(4, 3) }.to raise_error('Invalid Move')
        expect { bishop.move_to!(3, 2) }.to raise_error('Invalid Move')
        expect { bishop.move_to!(3, 4) }.to raise_error('Invalid Move')
      end
    end
    context 'when a move is obstructed' do
      it 'should raise error, when obstructed horizontally/vertically' do
        FactoryGirl.create(:queen, :is_on_board, color: 'black', game: game, row_coordinate: 4, column_coordinate: 4)
        FactoryGirl.create(:queen, :is_on_board, color: 'black', game: game, row_coordinate: 2, column_coordinate: 2)
        FactoryGirl.create(:queen, :is_on_board, color: 'black', game: game, row_coordinate: 4, column_coordinate: 2)
        FactoryGirl.create(:queen, :is_on_board, color: 'black', game: game, row_coordinate: 2, column_coordinate: 4)
        expect { bishop.move_to!(4, 4) }.to raise_error('Invalid Move')
        expect { bishop.move_to!(2, 2) }.to raise_error('Invalid Move')
        expect { bishop.move_to!(4, 2) }.to raise_error('Invalid Move')
        expect { bishop.move_to!(2, 4) }.to raise_error('Invalid Move')
      end
    end
  end
end
