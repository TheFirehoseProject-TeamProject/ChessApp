require 'rails_helper'

RSpec.describe Rook, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }
  let(:rook) { FactoryGirl.create(:rook, :is_on_board) }

  describe 'rook moves' do
    it 'should be a valid move' do
      expect(rook.valid_move?(4, 5)).to eq true
      expect(rook.valid_move?(0, 4)).to eq true
    end

    it 'should not be a valid move' do
      expect(rook.valid_move?(3, 3)).to eq false
      expect(rook.valid_move?(5, 5)).to eq false
    end

    it 'should not be a valid move' do
      expect(rook.valid_move?(4, 4)).to eq(false)
    end
  end
end
