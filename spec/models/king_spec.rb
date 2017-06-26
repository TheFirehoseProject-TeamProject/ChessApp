require 'rails_helper'

RSpec.describe King, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }
  let(:king) { FactoryGirl.create(:king, :is_on_board, color: 'white', game: game) }
  let(:king_black) { FactoryGirl.create(:king, :is_on_board, color: 'black', game: game, row_coordinate: 2, column_coordinate: 4) }
  describe 'movement of the king' do
    it 'should be able to move one field down' do
      king_black
      king.update_attributes(row_coordinate: 5, column_coordinate: 5)
      expect(king.valid_move?(5, 4)).to eq true
    end
    it 'should be able to move one field up' do
      king_black
      expect(king.valid_move?(4, 5)).to eq true
    end
    it 'should be able to move one field left' do
      king_black
      expect(king.valid_move?(3, 4)).to eq true
    end
    it 'should be able to move one field right' do
      king_black
      expect(king.valid_move?(5, 4)).to eq true
    end
    it 'should return true if it is a diagonal move' do
      king.update_attributes(row_coordinate: 5, column_coordinate: 5)
      king_black
      expect(king.valid_move?(4, 6)).to eq true
      expect(king.valid_move?(6, 6)).to eq true
      expect(king.valid_move?(4, 4)).to eq true
      expect(king.valid_move?(4, 6)).to eq true
    end
    it 'should return false if it moves more than field' do
      king_black
      expect(king.valid_move?(4, 6)).to eq false
    end
    it 'should return false if king tried to move next to other king' do
      king_black
      expect(king.valid_move?(4, 3)).to eq false
    end
  end
end
