require 'rails_helper'
RSpec::Matchers.define_negated_matcher :not_change, :change
RSpec.describe King, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user, game: game) }
  let(:king) { FactoryGirl.create(:king, :is_on_board, color: 'white', game: game) }
  let(:king_black) { FactoryGirl.create(:king, :is_on_board, color: 'black', game: game, row_coordinate: 2, column_coordinate: 4) }

  describe 'movement of the king' do
    it 'should be able to move one field down' do
      king.update_attributes(row_coordinate: 5, column_coordinate: 5)
      expect(king.valid_move?(5, 4)).to eq true
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
      king.update_attributes(row_coordinate: 5, column_coordinate: 5)
      expect(king.valid_move?(4, 6)).to eq true
      expect(king.valid_move?(6, 6)).to eq true
      expect(king.valid_move?(4, 4)).to eq true
      expect(king.valid_move?(4, 6)).to eq true
    end
    it 'should return false if it moves more than field' do
      expect(king.valid_move?(4, 6)).to eq false
    end
  end

  describe '#castle!' do
    let!(:user_w) { FactoryGirl.create(:user) }
    let!(:user_b) { FactoryGirl.create(:user) }
    let!(:game_c) { FactoryGirl.create(:game, turn: user_w.id, white_player: user_w, black_player: user_b) }
    let!(:king_cw) { FactoryGirl.create(:king, game: game_c, user: user_w, is_on_board?: true, column_coordinate: 4, row_coordinate: 0, color: 'white') }
    let!(:rook_crw) { FactoryGirl.create(:rook, game: game_c, user: user_w, is_on_board?: true, column_coordinate: 7, row_coordinate: 0, color: 'white') }
    let!(:rook_clw) { FactoryGirl.create(:rook, game: game_c, user: user_w, is_on_board?: true, column_coordinate: 0, row_coordinate: 0, color: 'white') }
    let!(:rook_crb) { FactoryGirl.create(:rook, game: game_c, user: user_b, is_on_board?: true, column_coordinate: 7, row_coordinate: 7, color: 'black') }
    let!(:rook_clb) { FactoryGirl.create(:rook, game: game_c, user: user_b, is_on_board?: true, column_coordinate: 0, row_coordinate: 7, color: 'black') }
    let!(:king_cb) { FactoryGirl.create(:king, game: game_c, user: user_b, is_on_board?: true, column_coordinate: 4, row_coordinate: 7, color: 'black') }
    context 'white castle move is successful' do
      it 'castle king side king coords update' do
        king_cw.castle!(7, 0)
        expect(king_cw).to have_attributes(column_coordinate: 6, row_coordinate: 0)
      end
      it 'castle king side rook coords update' do
        king_cw.castle!(7, 0)
        rook_crw.reload
        expect(rook_crw).to have_attributes(column_coordinate: 5, row_coordinate: 0)
      end
      it 'castle queen side king coords update' do
        king_cw.castle!(0, 0)
        expect(king_cw).to have_attributes(column_coordinate: 2, row_coordinate: 0)
      end
      it 'castle queen side rook coords update' do
        king_cw.castle!(0, 0)
        rook_clw.reload
        expect(rook_clw).to have_attributes(column_coordinate: 3, row_coordinate: 0)
      end
    end
    context 'black castle move is successful' do
      it 'castle king side king coords update' do
        king_cb.castle!(7, 7)
        expect(king_cb).to have_attributes(column_coordinate: 6, row_coordinate: 7)
      end
      it 'castle king side rook coords update' do
        king_cb.castle!(7, 7)
        rook_crb.reload
        expect(rook_crb).to have_attributes(column_coordinate: 5, row_coordinate: 7)
      end
      it 'castle queen side king coords update' do
        king_cb.castle!(0, 7)
        expect(king_cb).to have_attributes(column_coordinate: 2, row_coordinate: 7)
      end
      it 'castle queen side rook coords update' do
        king_cb.castle!(0, 7)
        rook_clb.reload
        expect(rook_clb).to have_attributes(column_coordinate: 3, row_coordinate: 7)
      end
    end
    context 'black castle move returns false' do
      let!(:bishop_crb) { FactoryGirl.create(:bishop, game: game_c, user: user_w, column_coordinate: 5, row_coordinate: 7, is_on_board?: true, color: 'black') }
      let!(:bishop_clb) { FactoryGirl.create(:bishop, game: game_c, user: user_w, column_coordinate: 2, row_coordinate: 7, is_on_board?: true, color: 'black') }
      it 'castle king side coords do not update' do
        expect { king_cb.castle!(7, 7) }.to raise_error('Invalid move')
          .and not_change(king_cb, :column_coordinate)
          .and not_change(king_cb, :row_coordinate)
          .and not_change(rook_crb, :column_coordinate)
          .and not_change(rook_crb, :row_coordinate)
      end
      it 'castle queen side coords do not update' do
        expect { king_cb.castle!(0, 7) }.to raise_error('Invalid move')
          .and not_change(king_cb, :column_coordinate)
          .and not_change(king_cb, :row_coordinate)
          .and not_change(rook_clb, :column_coordinate)
          .and not_change(rook_clb, :row_coordinate)
      end
    end
  end

  describe '#castle?' do
    let!(:game_c) { FactoryGirl.create(:game) }
    let!(:user_w) { FactoryGirl.create(:user) }
    let!(:king_cw) { FactoryGirl.create(:king, game: game_c, is_on_board?: true, column_coordinate: 4, row_coordinate: 0, color: 'white') }
    let!(:rook_cr) { FactoryGirl.create(:rook, game: game_c, is_on_board?: true, column_coordinate: 7, row_coordinate: 0, color: 'white') }
    let!(:rook_cl) { FactoryGirl.create(:rook, game: game_c, is_on_board?: true, column_coordinate: 0, row_coordinate: 0, color: 'white') }
    let!(:king_cb) { FactoryGirl.create(:king, game: game_c, is_on_board?: true, column_coordinate: 2, row_coordinate: 7, color: 'black') }
    context 'neither piece has moved' do
      it 'returns true to the right rook' do
        expect(king_cw.castle?(7, 0)).to eq true
      end
      it 'returns true to left rook' do
        expect(king_cw.castle?(0, 0)).to eq true
      end
    end
    context 'king has moved' do
      it 'castle king side returns false' do
        king_cw.move_to!(5, 0)
        expect(king_cw.castle?(7, 0)).to eq false
      end
      it 'castle queen side returns false' do
        king_cw.move_to!(5, 0)
        expect(king_cw.castle?(0, 0)).to eq false
      end
    end
    context 'right rook has moved' do
      it 'returns false to right rook' do
        rook_cr.move_to!(6, 0)
        expect(king_cw.castle?(6, 0)).to eq false
      end
      it 'returns true to left rook' do
        rook_cr.move_to!(6, 0)
        expect(king_cw.castle?(0, 0)).to eq true
      end
    end
    context 'left rook has moved' do
      it 'returns false to left rook' do
        rook_cl.move_to!(2, 0)
        expect(king_cw.castle?(2, 0)).to eq false
      end
      it 'returns true to right rook' do
        rook_cl.move_to!(3, 0)
        expect(king_cw.castle?(7, 0)).to eq true
      end
    end
    context 'piece is between rook and castle' do
      it 'returns false' do
        FactoryGirl.create(:bishop, game: game_c, user: user_w, is_on_board?: true, column_coordinate: 5, row_coordinate: 0, color: 'white')
        expect(king_cw.castle?(7, 0)).to eq false
      end
    end
    context 'game is in check' do
      it 'returns false' do
        FactoryGirl.create(:queen, game: game_c, user: user_w, is_on_board?: true, column_coordinate: 4, row_coordinate: 7, color: 'black')
        expect(king_cw.castle?(7, 0)).to eq false
      end
    end
    context 'king moves through space in check' do
      it 'returns false' do
        FactoryGirl.create(:queen, game: game_c, user: user_w, is_on_board?: true, column_coordinate: 5, row_coordinate: 7, color: 'black')
        expect(king_cw.castle?(7, 0)).to eq false
      end
    end
    context 'castling results in check' do
      it 'returns false' do
        FactoryGirl.create(:queen, game: game_c, user: user_w, is_on_board?: true, column_coordinate: 6, row_coordinate: 7, color: 'black')
        expect(king_cw.castle?(7, 0)).to eq false
      end
    end
  end
end
