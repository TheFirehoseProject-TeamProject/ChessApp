require 'rails_helper'

RSpec.describe King, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }
  let(:king) { FactoryGirl.create(:king, :is_on_board, color: 'black', game: game) }
  describe 'movement of the king' do
    it 'should be able to move one field down' do
      expect(king.valid_move?(4, 3)).to eq true
    end
    it 'should be able to move one field up' do
      expect(king.valid_move?(4, 5)).to eq true
    end
    it 'should be able to move one field left' do
      expect(king.valid_move?(3, 4)).to eq true
    end
    it 'should be able to move one field right' do
      expect(king.valid_move?(5, 4)).to eq true
    end
    it 'should return true if it is a diagonal move' do
      expect(king.valid_move?(3, 5)).to eq true
      expect(king.valid_move?(5, 5)).to eq true
      expect(king.valid_move?(3, 3)).to eq true
      expect(king.valid_move?(5, 3)).to eq true
    end
    it 'should return false if it moves more than field' do
      expect(king.valid_move?(4, 6)).to eq false
    end
  end
  describe '#move_to!' do
    context 'when a move is invalid' do
      it 'should raise error: Invalid Move' do
        expect { king.move_to!(2, 4) }.to raise_error('Invalid Move')
        expect { king.move_to!(6, 4) }.to raise_error('Invalid Move')
        expect { king.move_to!(4, 2) }.to raise_error('Invalid Move')
        expect { king.move_to!(4, 6) }.to raise_error('Invalid Move')
        expect { king.move_to!(3, 3) }.to raise_error('Invalid Move')
      end
    end
    context 'when a move is obstructed' do
      it 'should raise error, when obstructed horizontally/vertically' do
        FactoryGirl.create(:bishop, :is_on_board, color: 'black', game: game, row_coordinate: 4, column_coordinate: 3)
        FactoryGirl.create(:bishop, :is_on_board, color: 'black', game: game, row_coordinate: 4, column_coordinate: 5)
        FactoryGirl.create(:bishop, :is_on_board, color: 'black', game: game, row_coordinate: 3, column_coordinate: 4)
        FactoryGirl.create(:bishop, :is_on_board, color: 'black', game: game, row_coordinate: 5, column_coordinate: 4)
        expect { king.move_to!(4, 3) }.to raise_error('Invalid Move')
        expect { king.move_to!(4, 5) }.to raise_error('Invalid Move')
        expect { king.move_to!(3, 4) }.to raise_error('Invalid Move')
        expect { king.move_to!(5, 4) }.to raise_error('Invalid Move')
      end
      it 'should raise error, when obstructed diagonally' do
        FactoryGirl.create(:bishop, :is_on_board, color: 'black', game: game, row_coordinate: 3, column_coordinate: 3)
        FactoryGirl.create(:bishop, :is_on_board, color: 'black', game: game, row_coordinate: 3, column_coordinate: 5)
        FactoryGirl.create(:bishop, :is_on_board, color: 'black', game: game, row_coordinate: 5, column_coordinate: 5)
        FactoryGirl.create(:bishop, :is_on_board, color: 'black', game: game, row_coordinate: 5, column_coordinate: 3)
        expect { king.move_to!(3, 3) }.to raise_error('Invalid Move')
        expect { king.move_to!(3, 5) }.to raise_error('Invalid Move')
        expect { king.move_to!(5, 5) }.to raise_error('Invalid Move')
        expect { king.move_to!(5, 3) }.to raise_error('Invalid Move')
      end
    end
  end
end
