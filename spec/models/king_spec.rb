require 'rails_helper'

RSpec.describe King, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user, game: game) }
  let(:king) { FactoryGirl.create(:king, :is_on_board) }

  describe 'movement of the king' do
    it 'should be able to move one field down' do
      expect(king.valid_move?(4, 3)).to eq true
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
      expect(king.valid_move?(3, 5)).to eq true
      expect(king.valid_move?(5, 5)).to eq true
      expect(king.valid_move?(3, 3)).to eq true
      expect(king.valid_move?(3, 5)).to eq true
    end
    it 'should return false if it moves more than field' do
      expect(king.valid_move?(4, 6)).to eq false
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
      it 'returns false' do
        king_cw.move_to!(5, 0)
        expect(king_cw.castle?(7, 0)).to eq false
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
