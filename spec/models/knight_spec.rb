require 'rails_helper'

RSpec.describe Knight, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:knight) { FactoryGirl.create(:knight, :is_on_board, color: 'black', game: game) }

  describe '#valid_move?' do
    context 'moving up and right' do
      it 'up one right two returns true' do
        expect(knight.valid_move?(4, 4)).to eq true
      end
      it 'up two right one returns true' do
        expect(knight.valid_move?(3, 5)).to eq true
      end
    end

    context 'moving up and left' do
      it 'up one left two returns true' do
        expect(knight.valid_move?(0, 4)).to eq true
      end
      it 'up two left one returns true' do
        expect(knight.valid_move?(1, 5)).to eq true
      end
    end

    context 'moving down and left' do
      it 'down one left two returns true' do
        expect(knight.valid_move?(0, 2)).to eq true
      end
      it 'down two left one returns true' do
        expect(knight.valid_move?(1, 1)).to eq true
      end
    end

    context 'moving down and right' do
      it 'down one right two returns true' do
        expect(knight.valid_move?(4, 2)).to eq true
      end
      it 'down two right one returns true' do
        expect(knight.valid_move?(3, 1)).to eq true
      end
    end

    context 'invalid move' do
      it 'returns false' do
        expect(knight.valid_move?(5, 5)).to eq false
      end
    end
  end
  describe '#move_to!' do
    context 'when a move is invalid' do
      it 'should raise error: Invalid Move' do
        expect { knight.move_to!(1, 3) }.to raise_error('Invalid Move')
        expect { knight.move_to!(3, 3) }.to raise_error('Invalid Move')
        expect { knight.move_to!(2, 4) }.to raise_error('Invalid Move')
        expect { knight.move_to!(2, 5) }.to raise_error('Invalid Move')
        expect { knight.move_to!(1, 4) }.to raise_error('Invalid Move')
        expect { knight.move_to!(1, 2) }.to raise_error('Invalid Move')
        expect { knight.move_to!(3, 4) }.to raise_error('Invalid Move')
        expect { knight.move_to!(3, 2) }.to raise_error('Invalid Move')
      end
    end
  end
end
