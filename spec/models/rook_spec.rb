require 'rails_helper'

RSpec.describe Rook, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }
  let(:rook) { FactoryGirl.create(:queen, :is_on_board, color: 'black', game: game) }

  describe '#move_to!' do
    context 'when a move is obstructed' do
      it 'should raise error, when obstructed horizontally/vertically' do
        FactoryGirl.create(:rook, :is_on_board, color: 'black', game: game, row_coordinate: 3)
        FactoryGirl.create(:rook, :is_on_board, color: 'black', game: game, row_coordinate: 5)
        FactoryGirl.create(:rook, :is_on_board, color: 'black', game: game, column_coordinate: 3)
        FactoryGirl.create(:rook, :is_on_board, color: 'black', game: game, column_coordinate: 5)
        expect { rook.move_to!(3, 4) }.to raise_error('Invalid Move')
        expect { rook.move_to!(5, 4) }.to raise_error('Invalid Move')
        expect { rook.move_to!(4, 3) }.to raise_error('Invalid Move')
        expect { rook.move_to!(4, 5) }.to raise_error('Invalid Move')
      end
    end
  end
end
