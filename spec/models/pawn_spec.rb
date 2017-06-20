require 'rails_helper'

RSpec.describe Pawn, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }
  let(:pawn_black) { FactoryGirl.create(:pawn, :is_on_board, color: 'black', game: game) }
  let(:pawn_white) { FactoryGirl.create(:pawn, :is_on_board, color: 'white', row_coordinate: 1, game: game) }
  let(:pawn_center) { FactoryGirl.create(:pawn, :is_on_board, row_coordinate: 3, game: game) }

  describe '#valid_move?' do
    it 'white pawn should be able to move one field up' do
      expect(pawn_white.valid_move?(1, 2)).to eq true
    end
    it 'white pawn should be able to move two fields up when on row 1' do
      expect(pawn_white.valid_move?(1, 3)).to eq true
    end
    it 'white pawn should not be able to move one field down' do
      expect(pawn_white.valid_move?(1, 0)).to eq false
    end
    it 'black pawn should be able to move one field down' do
      expect(pawn_black.valid_move?(1, 5)).to eq true
    end
    it 'black pawn should be able to move two fields down when on row 6' do
      expect(pawn_black.valid_move?(1, 4)).to eq true
    end
    it 'black pawn should not be able to move one field up' do
      expect(pawn_black.valid_move?(1, 7)).to eq false
    end
    it 'pawn should not be able to move left' do
      expect(pawn_white.valid_move?(0, 1)).to eq false
    end
    it 'pawn should not be able to move right' do
      expect(pawn_white.valid_move?(2, 1)).to eq false
    end
    it 'should return false if it is a diagonal move' do
      expect(pawn_white.valid_move?(2, 2)).to eq false
    end
    it 'should return false if it moves more than field and not on row 6 or 1' do
      expect(pawn_center.valid_move?(1, 1)).to eq false
    end
    it 'should return false if it moves one field up/down and there is an opponent piece at the destination' do
      FactoryGirl.create(:pawn, column_coordinate: 1, row_coordinate: 2, color: 'black', game: game, is_on_board?: true)
      expect(pawn_white.valid_move?(1, 2)).to eq false
    end
    it 'should return false if it moves two field up/down and there is an opponent piece at the destination' do
      FactoryGirl.create(:pawn, column_coordinate: 1, row_coordinate: 3, color: 'black', game: game, is_on_board?: true)
      expect(pawn_white.valid_move?(1, 3)).to eq false
    end
    it 'white pawn should be able to move diagonal up right when capturing a piece' do
      FactoryGirl.create(:pawn, column_coordinate: 2, row_coordinate: 2, game: game)
      expect(pawn_white.valid_move?(2, 2)).to eq true
    end
    it 'white pawn should be able to move diagonal up left when capturing a piece' do
      FactoryGirl.create(:pawn, column_coordinate: 0, row_coordinate: 2, game: game)
      expect(pawn_white.valid_move?(0, 2)).to eq true
    end
    it 'black pawn should be able to move diagonal down right when capturing a piece' do
      FactoryGirl.create(:pawn, column_coordinate: 2, row_coordinate: 5, game: game)
      expect(pawn_black.valid_move?(2, 5)).to eq true
    end
    it 'black pawn should be able to move diagonal down left when capturing a piece' do
      FactoryGirl.create(:pawn, column_coordinate: 0, row_coordinate: 5, game: game)
      expect(pawn_black.valid_move?(0, 5)).to eq true
    end
    it 'should be able to capture a piece by en passant if other player has moves his pawn two steps before' do
      pawn_en_passant = FactoryGirl.create(:pawn, column_coordinate: 2, row_coordinate: 4, game: game, color: 'white')
      pawn_black.move_to!(1, 4)
      pawn_en_passant.move_to!(1, 5)
      pawn_black.reload
      expect(pawn_black).to have_attributes(column_coordinate: -1, row_coordinate: -1, is_on_board?: false)
      expect(pawn_en_passant).to have_attributes(column_coordinate: 1, row_coordinate: 5)
    end
  end
end
