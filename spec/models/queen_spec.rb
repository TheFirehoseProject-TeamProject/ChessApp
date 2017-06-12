require 'rails_helper'

RSpec.describe Queen, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }
  let(:queen) { FactoryGirl.create(:queen, :is_on_board) }

  describe 'queen#valid_move?' do
    it 'should return true for moves to the left' do
      expect(queen.valid_move?(3, 4)).to eq(true)
      expect(queen.valid_move?(1, 4)).to eq(true)
    end

    it 'should return true for moves to the right' do
      expect(queen.valid_move?(5, 4)).to eq(true)
      expect(queen.valid_move?(7, 4)).to eq(true)
    end

    it 'should return true for moves up' do
      expect(queen.valid_move?(4, 5)).to eq(true)
      expect(queen.valid_move?(4, 7)).to eq(true)
    end

    it 'should return true for moves down' do
      expect(queen.valid_move?(4, 3)).to eq(true)
      expect(queen.valid_move?(4, 7)).to eq(true)
    end

    it 'should return true for diagonal moves' do
      expect(queen.valid_move?(6, 2)).to eq(true)
      expect(queen.valid_move?(2, 2)).to eq(true)
      expect(queen.valid_move?(6, 6)).to eq(true)
      expect(queen.valid_move?(2, 6)).to eq(true)
    end

    it 'should return false for moves that are not left, right, up, down, or in a diagonal' do
      expect(queen.valid_move?(2, 3)).to eq(false)
      expect(queen.valid_move?(3, 6)).to eq(false)
    end
  end
end
