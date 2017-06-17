require 'rails_helper'

RSpec.describe Rook, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }
  let(:rook) { FactoryGirl.create(:rook, :is_on_board) }

  describe 'rook moves' do
    it 'should be a valid move' do
      expect(rook.valid_move?(4, 5)). to eq true
      expect(rook.valid_move?(0, 4)). to eq true
    end

    it 'should be an invalid move' do
      expect(rook.valid_move?(6, 5)). to raise_error('Error: Invalid Input')
      expect(rook.valid_move?(7, 7)). to raise_error('Error: Invalid Input')
      expect(rook.valid_move?(6, 2)). to raise_error('Error: Invalid Input')
    end
  end
end
