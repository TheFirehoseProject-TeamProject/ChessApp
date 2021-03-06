require 'rails_helper'

RSpec.describe Bishop, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }
  let(:bishop) { FactoryGirl.create(:bishop, :is_on_board) }
  let(:pawn) { FactoryGirl.create(:pawn, :is_on_board) }
  describe 'movement of bishop' do
    it 'should move diagonally up and left' do
      expect(bishop.valid_move?(2, 4)).to eq true
    end
    it 'should move diagonally up and right' do
      expect(bishop.valid_move?(4, 4)).to eq true
    end
    it 'should only move diagonally down and left' do
      expect(bishop.valid_move?(2, 2)).to eq true
    end
    it 'should only move diagonally down and right' do
      expect(bishop.valid_move?(4, 2)).to eq true
    end
    it 'should move more than one step diagonally' do
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
end
