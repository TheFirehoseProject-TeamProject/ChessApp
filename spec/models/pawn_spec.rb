require 'rails_helper'
RSpec::Matchers.define_negated_matcher :not_change, :change

RSpec.describe Pawn, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }
  let(:pawn_black) { FactoryGirl.create(:pawn, :is_on_board, color: 'black', game: game) }
  let(:pawn_white) { FactoryGirl.create(:pawn, :is_on_board, color: 'white', row_coordinate: 1, game: game) }
  let(:pawn_center) { FactoryGirl.create(:pawn, :is_on_board, row_coordinate: 3, game: game) }
  let(:pawn_en_passant) { FactoryGirl.create(:pawn, column_coordinate: 2, row_coordinate: 4, game: game, color: 'white') }
  let!(:black_king) { FactoryGirl.create(:king, game: game, column_coordinate: 4, row_coordinate: 7, color: 'black', is_on_board?: true) }
  let!(:white_king) { FactoryGirl.create(:king, game: game, column_coordinate: 4, row_coordinate: 0, color: 'white', is_on_board?: true) }

  describe '#promote!' do
    context 'pawn reaches opposite side of the board' do
      let(:game_pp) { FactoryGirl.create(:game) }
      let!(:queen) { FactoryGirl.create(:queen, game: game_pp, column_coordinate: 0, row_coordinate: 7, is_on_board?: true, color: 'black') }
      let(:pawn) { FactoryGirl.create(:pawn, game: game_pp, column_coordinate: 1, row_coordinate: 6, is_on_board?: true, color: 'white') }
      let!(:king_w) { FactoryGirl.create(:king, game: game_pp, column_coordinate: 7, row_coordinate: 0, is_on_board?: true, color: 'white') }
      let!(:black_king) { FactoryGirl.create(:king, game: game_pp, column_coordinate: 4, row_coordinate: 7, color: 'black', is_on_board?: true) }

      it 'pawn promotes' do

        pawn_black.update(row_coordinate: 1)
        expect{ pawn_black.move_to!(1, 0) }.to change { pawn_black.type }
        byebug
      end

      it 'pawn cannot move because of check' do
        expect{ pawn.move_to!(1, 7) }.to raise_error('This places you in check')
          .and not_change(pawn, :column_coordinate)
          .and not_change(pawn, :row_coordinate)
          .and not_change(pawn, :type)
      end
    end

    context 'pawn has not reached the opposite side' do
      it 'should not promote the pawn' do
        pawn_black.update(row_coordinate: 2)
        expect{ pawn_black.move_to!(1, 1) }.to not_change { pawn_black.type }
      end
    end
  end

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
    it 'should be able to move en passant if en passant situation' do
      pawn_black.move_to!(1, 4)
      pawn_en_passant.move_to!(1, 5)
      expect(pawn_en_passant).to have_attributes(column_coordinate: 1, row_coordinate: 5)
    end
    it 'should capture the piece if moving en passant' do
      pawn_en_passant
      pawn_black.move_to!(1, 4)
      pawn_en_passant.move_to!(1, 5)
      pawn_black.reload
      expect(pawn_black).to have_attributes(column_coordinate: -1, row_coordinate: -1, is_on_board?: false)
    end
    it 'should not move if no en passant situation and trying to move en passant' do
      pawn_en_passant.move_to!(1, 5)
      expect(pawn_en_passant.valid_move?(1, 5)).to eq false
    end
    it 'should not move en passant if the last move was not a two step pawn move which created en passant situation' do
      pawn_black2 = FactoryGirl.create(:pawn, color: 'black', row_coordinate: 6, column_coordinate: 6, game: game)
      pawn_black.move_to!(1, 4)
      pawn_white.move_to!(1, 3)
      pawn_black2.move_to!(6, 4)
      pawn_en_passant.move_to!(1, 5)
      expect(pawn_en_passant.valid_move?(1, 5)).to eq false
    end
  end

  describe '#move_to!' do
    let(:game_ep) { FactoryGirl.create(:game) }
    let!(:user_ep_w) { FactoryGirl.create(:user, game_id: game_ep) }
    let!(:user_ep_b) { FactoryGirl.create(:user, game_id: game_ep) }
    let!(:white_king) { FactoryGirl.create(:king, game: game_ep, column_coordinate: 7, row_coordinate: 0, color: 'white', is_on_board?: true, user: user_ep_w) }
    let!(:white_pawn) { FactoryGirl.create(:pawn, game: game_ep, column_coordinate: 3, row_coordinate: 4, color: 'white', is_on_board?: true, user: user_ep_w) }
    let!(:black_pawn) { FactoryGirl.create(:pawn, game: game_ep, column_coordinate: 4, row_coordinate: 6, color: 'black', is_on_board?: true, user: user_ep_b) }
    let!(:black_bishop) { FactoryGirl.create(:bishop, game: game_ep, column_coordinate: 0, row_coordinate: 7, color: 'black', is_on_board?: true, user: user_ep_b) }
    let!(:black_king) { FactoryGirl.create(:king, game: game_ep, column_coordinate: 4, row_coordinate: 7, color: 'black', is_on_board?: true, user: user_ep_b) }
    context 'when capturing a piece w/ en passant places you in check' do
      it 'returns error: This places you in check' do
        black_pawn.move_to!(4, 4)
        expect { white_pawn.move_to!(4, 5) }
          .to raise_error('This places you in check')
          .and not_change(white_pawn, :column_coordinate)
          .and not_change(white_pawn, :row_coordinate)
          .and not_change(black_pawn, :is_on_board?)
          .and not_change(black_pawn, :column_coordinate)
          .and not_change(black_pawn, :row_coordinate)
      end
    end
  end
end
